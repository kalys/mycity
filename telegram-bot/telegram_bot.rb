require 'telegram/bot'
require 'redis-objects'
require 'json'
require 'pry'

raise "Set BOT_TOKEN environment variable" if ENV.fetch('BOT_TOKEN').nil?

NEW_REPORT_BUTTON = "Сообщить о новой проблеме".freeze
SUBMIT_REPORT_BUTTON = "Сообщить о проблеме".freeze
SEND_GEOPOSITION_BUTTON = "Отправить геопозицию".freeze
CANCEL_BUTTON = "Отменить".freeze

def welcome_user(bot, message)
  bot.api.send_message(chat_id: message.chat.id, text: "Чтобы описать проблему нажмите на кнопку \"#{NEW_REPORT_BUTTON}\"")

  buttons = [Telegram::Bot::Types::KeyboardButton.new(text: NEW_REPORT_BUTTON)]
  markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons, resize_keyboard: true)
  bot.api.send_message(chat_id: message.chat.id, text: "Чтобы отправить ее на модерацию нажмите на кнопку \"Сообщить о проблеме\".",
                      reply_markup: markup)
end

def show_submit_button
  buttons = [
    Telegram::Bot::Types::KeyboardButton.new(text: SUBMIT_REPORT_BUTTON),
    Telegram::Bot::Types::KeyboardButton.new(text: CANCEL_BUTTON)
  ]
  markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons, resize_keyboard: true)
  bot.api.send_message(chat_id: message.chat.id, text: "Чтобы отправить ее на модерацию нажмите на кнопку \"Сообщить о проблеме\".",
                      reply_markup: markup)
end

Telegram::Bot::Client.run(ENV.fetch('BOT_TOKEN'), logger: Logger.new(STDOUT)) do |bot|
  bot.listen do |message|

    unless message.chat.type == "private"
      bot.api.send_message(chat_id: message.chat.id, text: "Репорты принимаются только в приватных чатах")
      return
    end

    message_text = message.text
    list_name = "messages-#{message.chat.id}"

    if message_text == "/start" || message_text == CANCEL_BUTTON || message_text == "/cancel"
      Redis::List.new(list_name).clear
      welcome_user(bot, message)


    elsif message_text == NEW_REPORT_BUTTON || message_text == "/new"
      buttons = [Telegram::Bot::Types::KeyboardButton.new(text: SEND_GEOPOSITION_BUTTON, request_location: true)]
      markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: buttons, resize_keyboard: true, one_time_keyboard: true)
      bot.api.send_message(chat_id: message.chat.id,
                          text: "Отправьте вашу геопозицию или введите адрес вручную",
                          reply_markup: markup)


    elsif message_text == SUBMIT_REPORT_BUTTON || message_text == "/submit"
      list = Redis::List.new(list_name)
      json = list.values.to_json
      list.clear
      # send json to server
      puts json
      welcome_user(bot, message)


    elsif message.location
      list = Redis::List.new(list_name, marshal: true)
      list << {type: :location, lat: message.location.latitude, lng: message.location.longitude}

    elsif message.photo.any?
      list = Redis::List.new(list_name, marshal: true)
      list << {type: :file, file_id: message.photo[2].file_id}
    elsif message_text
      list = Redis::List.new(list_name, marshal: true)
      list << {type: :text, text: message_text}
    end
  end
end
