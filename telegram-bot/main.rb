require 'telegram/bot'
require 'fileutils'
require 'open-uri'
require './session.rb'

class FixMyStreet
	def initialize
		@TOKEN     = '500989121:AAFjlkE097YZkyEe9F6jqB8rq0AObyU0Gr0'
		@sessions  = []
		@session   = nil
	end

	def run
		Telegram::Bot::Client.run(@TOKEN, logger: Logger.new(STDOUT)) do |bot|
			bot.listen do |message|
				current_chat = message.chat.id

				check_session(current_chat)

				if message.text == '/start'
					bot.api.send_message(chat_id: message.chat.id, text: 'Здрасте, Вы можете мне отправить проблему написав /new')
				elsif message.text == '/new'
					@session.status = '/new'
				elsif message.text == '/end' && @session.status != nil
					@session.send_parameters

					bot.api.send_message(chat_id: current_chat, text: 'Ваше сообщение отправлено на модерацию.')
				end


				case @session.status
				when '/new'
					kb = Telegram::Bot::Types::KeyboardButton.new(text: 'Show me your location', request_location: true)
					markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
					bot.api.send_message(chat_id: current_chat, text: 'Вы можете отправить адрес написав где Вы находитесь, либо отправить ваши координаты, нажав кнопку "Show me your location"', reply_markup: markup)
					@session.status = 'location'
				when 'location'
					unless message.location.nil?
						@session.latitude = message.location.latitude
						@session.longitude = message.location.longitude
						@session.status = 'text'
						bot.api.send_message(chat_id: current_chat, text: 'Опишите проблему: ')
					else
						unless message.text.nil?
							@session.address = message.text
							@session.status = 'text'
							bot.api.send_message(chat_id: current_chat, text: 'Опишите проблему: ')
						else
							bot.api.send_message(chat_id: current_chat, text: 'Повторите попытку.')
						end
					end
				when 'text'
				  unless message.text.nil?
				  	@session.text = message.text
					  @session.status = 'images'
					  bot.api.send_message(chat_id: current_chat, text: 'Отправте изображения проблемы и когда закончите, напишите /end')
				  else
				  	bot.api.send_message(chat_id: current_chat, text: 'Повторите попытку.')
				  end
				when 'images'
					unless message.photo[0].nil?
						Dir.mkdir("./pictures/") unless File.exists?("./pictures/")
						Dir.mkdir("./pictures/#{current_chat}") unless File.exists?("./pictures/#{current_chat}/")

						file = bot.api.get_file(file_id: message.photo[2].file_id)
						file_path = file.dig('result', 'file_path')
						photo_url = "https://api.telegram.org/file/bot#{@TOKEN}/#{file_path}"
						File.write("./pictures/#{current_chat}/image_#{current_chat}.jpg", open(photo_url).read)

						path_to_file = "./pictures/#{current_chat}/image_#{current_chat}.jpg"

						@session.images.push(File.new(path_to_file, 'rb'))

						FileUtils.rm(path_to_file)
					else
						bot.api.send_message(chat_id: current_chat, text: 'Повторите попытку.')
					end
				end
			end
		end
	end

	private
	def check_session(chat_id)
		unless @sessions.any? {|session| session.chat_id == chat_id}
			@sessions.push(Session.new(chat_id))
		end

		@session = @sessions.find {|session| session.chat_id == chat_id}
	end
end

bot = FixMyStreet.new
bot.run