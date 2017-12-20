module TelegramBot
  require 'telegram/bot'
  require 'fileutils'
  require 'open-uri'
  require './session.rb'

  TOKEN = '500989121:AAFjlkE097YZkyEe9F6jqB8rq0AObyU0Gr0'



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

