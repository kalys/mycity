require 'telegram/bot'

class HandleMessageJob < ApplicationJob
  queue_as :default

  def perform(sender_id, items_json)
    @items = JSON.parse(items_json)

    if valid?
      message = Message.create(body: text, latitude: location['lat'], longitude: location['lng'],
                               sender_id: sender_id, sender_name: username, status: :for_moderation)
      if message.valid?
        images.each do |image_url|
          Image.create message: message, remote_image_url: image_url
        end
      end
    end
  end

  private

  # private reader
  def items
    @items
  end

  def valid?
    location.present? &&
      items.any? {|item| item['type'] == 'text' } &&
      items.any? {|item| item['type'] == 'file' }
  end

  def username
    items.find {|item| item['type'] == 'meta'}&.fetch('sender_name')
  end

  def location
    # `reverse` is used to find the most recent location
    @location ||= items.reverse.find {|item| item['type'] == 'location' }
  end

  def text
    @text ||= items.select {|item| item['type'] == 'text'}.join('\n')
  end

  def images
    api = Telegram::Bot::Api.new(ENV.fetch('BOT_TOKEN'))
    items.select {|item| item['type'] == 'file'}.map do |item|
      file_id = item['file_id']
      response = api.getFile(file_id: file_id)
      "https://api.telegram.org/file/bot#{ENV.fetch('BOT_TOKEN')}/#{response['result']['file_path']}"
    end
  end
end
