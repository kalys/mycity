require 'telegram/bot'
require 'redis-objects'

namespace :mycity do
  desc "Start bot"
  task start_bot: :environment do
    $stdout.sync = true
    # Trap ^C
    Signal.trap("INT") {
      puts "Terminated by SIGINT"
      exit
    }

    # Trap `Kill`
    Signal.trap("TERM") {
      puts "Terminated by SIGTERM"
      exit
    }

    raise "Set BOT_TOKEN environment variable" if ENV.fetch('BOT_TOKEN').nil?

    SUBMIT_REPORT_BUTTON = "Сообщить о проблеме".freeze
    SEND_GEOPOSITION_BUTTON = "Отправить геопозицию".freeze
    CANCEL_BUTTON = "Отменить".freeze

    EXPIRATION_SECONDS = 60 * 60 * 24

    def welcome_user(bot, message)
      buttons = [
        Telegram::Bot::Types::KeyboardButton.new(text: SEND_GEOPOSITION_BUTTON, request_location: true),
        Telegram::Bot::Types::KeyboardButton.new(text: SUBMIT_REPORT_BUTTON),
        Telegram::Bot::Types::KeyboardButton.new(text: CANCEL_BUTTON),
      ]
      markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons, resize_keyboard: true)
      bot.api.send_message(chat_id: message.chat.id, text: "Чтобы отправить сообщение о проблеме на модерацию нажмите на кнопку \"Сообщить о проблеме\".",
                          reply_markup: markup)
    end

    logger = Logger.new($stdout)
    if ENV['BOT_TOKEN'] == 'development'
      logger.level = Logger::DEBUG
    end

    Telegram::Bot::Client.run(ENV.fetch('BOT_TOKEN'), logger: logger) do |bot|
      bot.listen do |message|

        unless message.chat.type == "private"
          bot.api.send_message(chat_id: message.chat.id, text: "Репорты принимаются только в приватных чатах")
          return
        end

        redis_list = Redis::List.new("messages-#{message.chat.id}-#{message.from.id}", marshal: true, expiration: EXPIRATION_SECONDS, maxlength: 50)

        if message.text == "/start" || message.text == CANCEL_BUTTON || message.text == "/cancel"
          redis_list.clear
          redis_list << {type: :meta, sender_name: message.from.username}
          welcome_user(bot, message)
          bot.logger.debug("List state #{redis_list}")


        elsif message.text == SUBMIT_REPORT_BUTTON || message.text == "/submit"
          key = redis_list.key.split('-').last
          HandleMessageJob.perform_later key, redis_list.values.to_json
          redis_list.clear
          welcome_user(bot, message)


        elsif message.location
          redis_list << {type: :location, lat: message.location.latitude, lng: message.location.longitude}
          bot.logger.debug("List state #{redis_list}")

        elsif message.photo.any?
          redis_list << {type: :file, file_id: message.photo[2].file_id}
          bot.logger.debug("List state #{redis_list}")

        elsif message.text
          redis_list << {type: :text, text: message.text}
          bot.logger.debug("List state #{redis_list}")
        end
      end
    end
  end
end
