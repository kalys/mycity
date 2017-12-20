module TelegramBot
  require 'telegram/bot'
  require 'fileutils'
  require 'open-uri'
  require './session.rb'

  TOKEN = '484322269:AAGmC6awc5ZWBev9PYkgEfE1tJjHXbeqvmc'

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
      def greeting
        "Привет, чтобы описать\nпроблему нажмите на кнопку \"Новая проблема\".\nЧтобы отправить ее на модерацию\nнажмите на кнопку \"Отправить сообщение\"."
      end

      def success_input
        "Ваще сообщение\nпринято и отправлено\nна модерацию"
      end

      def error
        "Простите, но я Вас не понимаю.\nУбедитесь, что вводите корректные данные"
      end

      def location
        "Отправьте вашу геолокацию\nили введите адрес вручную"
      end

      def information_message
        "Теперь Вы можете отправить любое количество сообщений и фотографий"
      end
    end
  end
end

