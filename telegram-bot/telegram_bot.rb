module TelegramBot
  require 'telegram/bot'
  require 'fileutils'
  require 'open-uri'
  require './session.rb'

  # TOKEN = '500989121:AAFjlkE097YZkyEe9F6jqB8rq0AObyU0Gr0'
TOKEN = '484322269:AAGmC6awc5ZWBev9PYkgEfE1tJjHXbeqvmc'
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
          check_session(current_chat)
          case command.text
          when '/start'
            bot.api.send_message(chat_id: current_chat,
                                text: UserMessages.first_greeting_message)
            bot.api.send_message(chat_id: current_chat,
                                text: UserMessages.second_greeting_message,
                                reply_markup: UserMessages.buttons('Сообщить о новой проблеме'))
          when 'Сообщить о новой проблеме'
            Location.new(current_chat, @session).get_adress
            @session.check_address = @session.address
            bot.api.send_message(chat_id: current_chat,
                                text: UserMessages.information_message,
                                reply_markup: UserMessages.buttons('Сообщить о проблеме'))
            bot.listen do |message|
              if message.text == 'Сообщить о проблеме'
                @session.send_parameters
                bot.api.send_message(chat_id: current_chat,
                                    text: UserMessages.success_input,
                                    reply_markup: UserMessages.buttons('Сообщить о новой проблеме'))
                break
              else
                Message.new(message, current_chat, @session).save_message
              end
            end
          else
            bot.api.send_message(chat_id: current_chat, text: UserMessages.error)
          end
        end
      end
    end

    def check_session(chat_id)
      @sessions.push(Session.new(chat_id)) unless @sessions.any? {|session| session.chat_id == chat_id}
      @session = @sessions.find {|session| session.chat_id == chat_id}
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
        bot.api.send_message(chat_id: @current_chat,
                            text: UserMessages.location,
                            reply_markup: UserMessages.buttons('Отправить геопозицию', true))
        bot.listen do |location_message|
          next if location_message.text == 'Сообщить о новой проблеме'
          if !location_message.text.nil?
            @session.address = location_message.text
            break
          elsif !location_message.location.nil?
            @session.latitude = location_message.location.latitude
            @session.longitude = location_message.location.longitude
            break
          else
            bot.api.send_message(chat_id: @current_chat, text: UserMessages.error)
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
      else
        @session.check_address = nil
      end
    end
  end

  class UserMessages
    class << self
      def first_greeting_message
        "Привет!\nЧтобы описать проблему\nнажмите на кнопку\n\"Сообщить о новой проблеме\""
      end

      def second_greeting_message
        "Чтобы отправить ее на модерацию\nнажмите на кнопку\n\"Сообщить о проблеме\"."
      end

      def success_input
        "Ваще сообщение\nпринято и отправлено\nна модерацию"
      end

      def error
        "Простите, но я Вас не понимаю.\nУбедитесь, что вводите корректные данные"
      end

      def location
        "Отправьте вашу геопозицию\nили введите адрес вручную"
      end

      def information_message
        "Теперь Вы можете отправить любое количество сообщений и фотографий. Чтобы отправить сообщение на модерацию нажмите на кнопку \"Сообщить о проблеме\""
      end

      def buttons(button_text, boolean=false)
        first_button = Telegram::Bot::Types::KeyboardButton.new(text: button_text, request_location: boolean)
        second_button = Telegram::Bot::Types::KeyboardButton.new(text: 'Отменить')
        if button_text == 'Сообщить о новой проблеме'
          markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [first_button], resize_keyboard: true)
        else
          markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [first_button, second_button], resize_keyboard: true)
        end
      end
    end
  end
end

