module TelegramBot
  require 'telegram/bot'
  require 'fileutils'
  require 'open-uri'
  require './session.rb'


  TOKEN = ENV.fetch('BOT_TOKEN')
  MODERATOR_CHAT_ID = ENV.fetch('MODERATORS_GROUP_ID')

  BOT_COMMAND = {
    start_bot: "/start",
    new_problem: "Сообщить о новой проблеме",
    send_problem: "Сообщить о проблеме",
    cancel_problem: "Отменить",
    send_geolocation: 'Отправить геопозицию'
  }
  class Run
    attr_accessor :session

    def initialize
      @sessions = []
      @session  = nil
    end

    def client_run
      Telegram::Bot::Client.run(TOKEN, logger: Logger.new(STDOUT)) do |bot|
        bot.listen do |command|
          current_chat = command.chat.id
          check_session(command)
          case command.text
          when BOT_COMMAND[:start_bot], BOT_COMMAND[:cancel_problem]
            UserMessages.bot_messages(command.text, current_chat)
          when BOT_COMMAND[:new_problem]
            Location.new(current_chat, @session).get_adress
            @session.check_address = @session.address
            UserMessages.bot_messages(command.text, current_chat)
            bot.listen do |message|
              if message.text == BOT_COMMAND[:send_problem]
                if @session.check_validation == true
                  @session.send_parameters
                  UserMessages.bot_messages(message.text, current_chat)
                  break
                else
                  bot.api.send_message(chat_id: current_chat, text: "Вы ввели не все данные")
                end
              elsif message.text == BOT_COMMAND[:cancel_problem]
                UserMessages.bot_messages(message.text, current_chat)
                break
              else
                Message.new(message, current_chat, @session).save_message
              end
            end
          else
            UserMessages.bot_messages(current_chat) unless current_chat == MODERATOR_CHAT_ID
          end
        end
      end
    end

    def check_session(message)
      @sessions.push(Session.new(message.chat.id, message.chat.username, message.chat.id)) unless @sessions.any? {|session| session.chat_id == message.chat.id}
      @session = @sessions.find {|session| session.chat_id == message.chat.id}
    end
  end

  class Message
    def initialize(message, current_chat, session)
      @message = message
      @current_chat = current_chat
      @session = session
    end

    def type
      type = 'geolocation' unless @message.location.nil?
      type = 'text' unless @message.text.nil?
      type = 'image' unless @message.photo[0].nil?
      type = 'incorrect' if type.nil?
      return type
    end

    def save_message
      case type
      when 'text'
        Text.new(@message, @current_chat, @session).get_text
      when 'image'
        Image.new(@message, @current_chat, @session).get_image
      when 'incorrect'
        Telegram::Bot::Client.run(TOKEN) do |bot|
          bot.api.send_message(chat_id: @current_chat, text: UserMessages.error)
        end
      end
    end
  end

  class Location
    def initialize(current_chat, session)
      @current_chat = current_chat
      @session = session
    end

    def get_adress
      Telegram::Bot::Client.run(TOKEN) do |bot|
        UserMessages.bot_messages(BOT_COMMAND[:send_geolocation], @current_chat)
        bot.listen do |location_message|
          next if location_message.text == BOT_COMMAND[:new_problem]
          if !location_message.text.nil?
            @session.address = location_message.text
            break
          elsif !location_message.location.nil?
            @session.latitude = location_message.location.latitude
            @session.longitude = location_message.location.longitude
            break
          else
            UserMessages.bot_messages(@current_chat)
          end
        end
      end
    end
  end

  class Image
    def initialize(message, current_chat, session)
      @message = message
      @current_chat = current_chat
      @session = session
    end

    def get_image
      Telegram::Bot::Client.run(TOKEN) do |bot|
        Dir.mkdir("./pictures/") unless File.exists?("./pictures/")
        Dir.mkdir("./pictures/#{@current_chat}") unless File.exists?("./pictures/#{@current_chat}/")

        file = bot.api.get_file(file_id: @message.photo[2].file_id)
        file_path = file.dig('result', 'file_path')
        photo_url = "https://api.telegram.org/file/bot#{TOKEN}/#{file_path}"
        File.write("./pictures/#{@current_chat}/image_#{@current_chat}.jpg", open(photo_url).read)
        path_to_file = "./pictures/#{@current_chat}/image_#{@current_chat}.jpg"
        @session.images.push(File.new(path_to_file, 'rb'))
        FileUtils.rm(path_to_file)
        @session.check_validation = true
      end
    end
  end

  class Text
    def initialize(message, current_chat, session)
      @message = message
      @session = session
      @current_chat = current_chat
    end

    def get_text
      if @session.check_address.nil?
        @session.text += @message.text + " "
        @session.check_validation = true
      else
        @session.check_address = nil
      end
    end
  end

  class UserMessages
    class << self
      def first_greeting_message
        "Чтобы описать проблему нажмите на кнопку \"Сообщить о новой проблеме\""
      end

      def second_greeting_message
        "Чтобы отправить ее на модерацию нажмите на кнопку \"Сообщить о проблеме\"."
      end

      def success_input
        "Ваще сообщение принято и отправлено на модерацию"
      end

      def error
        "Простите, но я Вас не понимаю. Убедитесь, что вводите корректные данные"
      end

      def location
        "Отправьте вашу геопозицию или введите адрес вручную"
      end

      def information_message
        "Теперь Вы можете отправить любое количество сообщений и фотографий. Чтобы отправить сообщение на модерацию нажмите на кнопку \"Сообщить о проблеме\""
      end

      def buttons(button_text, boolean=false)
        first_button = Telegram::Bot::Types::KeyboardButton.new(text: button_text, request_location: boolean)
        second_button = Telegram::Bot::Types::KeyboardButton.new(text: BOT_COMMAND[:cancel_problem])

        if button_text == BOT_COMMAND[:send_problem]
          markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [first_button, second_button], resize_keyboard: true)
        else
          markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [first_button], resize_keyboard: true)
        end
      end

      def bot_messages(message=nil, current_chat)
        Telegram::Bot::Client.run(TOKEN) do |bot|
          
          case message
          when BOT_COMMAND[:start_bot], BOT_COMMAND[:cancel_problem]
            bot.api.send_message(chat_id: current_chat, text: first_greeting_message)
            bot.api.send_message(chat_id: current_chat, text: second_greeting_message,
                                reply_markup: buttons(BOT_COMMAND[:new_problem]))
          when BOT_COMMAND[:new_problem]
            bot.api.send_message(chat_id: current_chat,
                                text: information_message,
                                reply_markup: buttons(BOT_COMMAND[:send_problem]))
          when BOT_COMMAND[:send_problem]
            bot.api.send_message(chat_id: MODERATOR_CHAT_ID,
                                text: "На сервере появилось новое обращение",
                                )

            bot.api.send_message(chat_id: current_chat,
                                text: success_input,
                                reply_markup: buttons(BOT_COMMAND[:new_problem]))
          when BOT_COMMAND[:send_geolocation]
            bot.api.send_message(chat_id: current_chat,
                                text: location,
                                reply_markup: buttons(BOT_COMMAND[:send_geolocation], true))
          else
            bot.api.send_message(chat_id: current_chat, text: error)
          end
        end
      end
    end
  end
end
