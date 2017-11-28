require 'telegram/bot'
require 'fileutils'
require 'open-uri'
require 'rest-client'

class Session
	attr_reader   :chat_id
	attr_accessor :status, :text, :images, :text, :address, :latitude, :longitude 

	def initialize(chat_id)
		@chat_id   = chat_id
		@status    = nil
		@text      = nil
		@address   = nil
		@latitude  = nil
		@longitude = nil
		@images    = []
	end

	def send_parameters
		RestClient.post('http://localhost:3000/messages', 
		{  :message => { 
				 category_id: 1,
				 longitude:   @longitude,
				 latitude:    @latitude,
				 address:     @address,
				 status:     'new_message', 
				 body:        @text },
		 
		 	 :image => {
				 image: @images }
		})	
	end
end

class FixMyStreet
	def initialize
		@TOKEN     = '499660598:AAF-INPO3WiMq2DfO7KFLyfgMrUlpi9RvVQ'
		@sessions  = []
		@session   = nil
	end

	def run
		Telegram::Bot::Client.run(@TOKEN, logger: Logger.new(STDOUT)) do |bot|
			bot.listen do |message|
				check_session(message.chat.id)			
				
				if message.text == '/end' && @session.status == nil
					message.text = ''
				end	

				case message.text 
				when '/start'
				  @session.status = '/start'
				when '/new'
          @session.status = '/new'
				when '/end'
					bot.api.send_message(chat_id: message.chat.id, text: 'Всё заебись, спасибо.')
	
					Dir["./pictures/#{message.chat.id}/*"].each do |file|
						@session.images.push(File.new(file, 'rb'))
					end	
					
					@session.send_parameters

					@sessions.delete(@sessions.find {|session| session.chat_id == message.chat.id})

					Dir["./pictures/#{message.chat.id}/*"].each do |file|	
						FileUtils.rm("#{file}")
					end	
				end	

				case @session.status
				when '/start'
					bot.api.send_message(chat_id: message.chat.id, text: 'Здрасте, Вы можете мне отправить проблему написав /new')
				when '/new'
					kb = Telegram::Bot::Types::KeyboardButton.new(text: 'Show me your location', request_location: true) 
					markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
					bot.api.send_message(chat_id: message.chat.id, text: 'Вы можете отправить адрес написав где Вы находитесь, либо отправить ваши координаты, нажав кнопку "Show me your location"', reply_markup: markup)
					@session.status = 'location'
				when 'location'
					unless message.location.nil?
						@session.latitude = message.location.latitude 
						@session.longitude = message.location.longitude
						@session.status = 'text'
						bot.api.send_message(chat_id: message.chat.id, text: 'Опишите проблему: ')	
					else 
						@session.address = message.text
						@session.status = 'text'
						bot.api.send_message(chat_id: message.chat.id, text: 'Опишите проблему: ')
					end					
				when 'text'	
				  @session.text = message.text
				  @session.status = 'images'
				  bot.api.send_message(chat_id: message.chat.id, text: 'Отправте изображения проблемы и когда закончите, напишите /end')
				when 'images'	
					unless message.photo[0].nil?
						Dir.mkdir("./pictures/") unless File.exists?("./pictures/")
						Dir.mkdir("./pictures/#{message.chat.id}") unless File.exists?("./pictures/#{message.chat.id}/")

						file = bot.api.get_file(file_id: message.photo[2].file_id) 
						file_path = file.dig('result', 'file_path')
						photo_url = "https://api.telegram.org/file/bot#{@TOKEN}/#{file_path}"
						File.write("./pictures/#{message.chat.id}/image_#{message.message_id}.jpg", open(photo_url).read)					
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