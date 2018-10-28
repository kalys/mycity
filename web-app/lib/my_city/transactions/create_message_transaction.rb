require 'dry/transaction'
require 'import'

module MyCity
  module Transactions
    class CreateMessageTransaction
      include Dry::Transaction
      include WebApp::Import[
        'logger',
        'my_city.repositories.admin_user_repository',
        'my_city.repositories.message_repository',
        'telegram.bot',
      ]

      around :transaction

      map :build
      check :validate
      map :create
      tee :notify_moderators
      tee :notify_reporter

      private

      def build(items)
        items = items.map { |item| item.symbolize_keys }
        Message.new(
          body: items.select { |item| item[:type] == 'text' }.map { |item| item[:text] }.join("\n"),
          location: items.reverse.find { |item| item[:type] == 'location' },
          sender_name: items.find { |item| item[:type] == 'meta' }&.fetch(:sender_name, nil),
          sender_id: items.find { |item| item[:type] == 'meta' }&.fetch(:sender_id, nil)
        ).tap do |message|
          message.built_images =
            items.select { |item| item[:type] == 'file' }.map do |item|
              file_id = item[:file_id]
              response = bot.api.getFile(file_id: file_id)
              "https://api.telegram.org/file/bot#{ENV.fetch('BOT_TOKEN')}/#{response['result']['file_path']}"
            end.map do |remote_url|
              logger.debug(remote_url)
              Image.create(remote_image_url: remote_url)
            end
        end
      end

      def validate(message)
        message.body.present? &&
          message.latitude.present? &&
          message.longitude.present? &&
          !message.built_images.empty?
      end

      def create(message)
        message_repository.create(message)
      end

      def notify_moderators(message)
        admin_user_repository.telegram_moderators.each do |user|
          bot.api.send_message(
            chat_id: user.telegram_login,
            text: "https://mycity.osmonov.com/messages/#{message.id}"
          )
        end
      rescue Telegram::Bot::Exceptions::ResponseError
        # do nothing
      end

      def notify_reporter(message)
        bot.api.send_message(
          chat_id: message.sender_id,
          text: "Ваше сообщение принято: https://mycity.osmonov.com/admin/messages/#{(message.id)}"
        )
      rescue Telegram::Bot::Exceptions::ResponseError
        # do nothing
      end

      def transaction(input, &block)
        result = nil
        rollback_exception = message_repository.rollback_exception

        begin
          message_repository.transaction do
            result = block.(Success(input))
            raise rollback_exception if result.failure?
            result
          end
        rescue rollback_exception
          result
        end
      end
    end
  end
end
