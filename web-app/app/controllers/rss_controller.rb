require "rss"
class RssController < ApplicationController
  skip_before_action :authenticate_user!, only: [:rss]

  def rss
    messages = Message.all

    rss = RSS::Maker.make("2.0") do |maker|
      maker.channel.author = "my-city"
      maker.channel.updated = Time.now.to_s
      maker.channel.link = "http://my-city.com/rss"
      maker.channel.description = "http://my-city.com/rss"
      maker.channel.title = "My City Feed"

      messages.each do |message|
        maker.items.new_item do |item|
          item.link = url_for(message)
          item.title = message.body.truncate(50)
          item.updated = message.created_at.to_s
        end
      end
    end

    render :plain => rss
  end
end
