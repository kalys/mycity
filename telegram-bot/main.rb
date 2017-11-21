require 'telegram/bot'
require 'fileutils'
require 'open-uri'
require 'rest-client'

TOKEN     = '499660598:AAF-INPO3WiMq2DfO7KFLyfgMrUlpi9RvVQ'
sessions  = []

Telegram::Bot::Client.run(TOKEN, logger: Logger.new(STDOUT)) do |bot|
	bot.listen do |message|
		unless sessions.any? {|session| session[:chat_id] == message.chat.id}
			sessions.push({
			chat_id: message.chat.id,
			status_of_session: '',
			status_of_problem: '',
			parameters: {
				category_id: nil,
				text_of_problem: '',
				latitude: nil,
				longitude: nil,
				images_of_problem: ''	},
			})
		end
						
	  session = sessions.find {|session| session[:chat_id] == message.chat.id}
	
		case message.text
		when '/start'
			bot.api.send_message(chat_id: message.chat.id, text: 'Здрасте, Вы можете мне отправить проблему написав /new')
			session[:status_of_session] = '/start'
		when '/new'	  
			session[:status_of_session] = '/new'
			session[:status_of_problem] = 'text_of_problem'
			bot.api.send_message(chat_id: message.chat.id, text: 'Отправте текст проблемы: ')
		when '/end'
			bot.api.send_message(chat_id: message.chat.id, text: 'Всё заебись, спасибо.')
			session[:status_of_problem] = ''
			file_name = Dir["./pictures/#{message.chat.id}/*"].last

			RestClient.post('http://localhost:3000/messages', 
			{  :message => { 
					 body: session[:parameters][:text_of_problem],
					 latitude: session[:parameters][:latitude],
					 longitude: session[:parameters][:longitude],
					 address: "location",
					 category_id: 1,
					 status: "new" },
			 
			 	 :image => {
					 image: File.new(file_name, 'rb')}
			})
		  	
			sessions.delete(sessions.find {|session| session[:chat_id] == message.chat.id})

			Dir["./pictures/#{message.chat.id}/*"].each do |file|	
				FileUtils.rm("#{file}")
			end	
		end
		
		kb = Telegram::Bot::Types::KeyboardButton.new(text: 'Show me your location', request_location: true) 
		markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
				
		case session[:status_of_problem]
		when 'text_of_problem' 
			if message.text != '/new'
				session[:parameters][:text_of_problem] = message.text
				session[:status_of_problem] = 'location_of_problem'
				bot.api.send_message(chat_id: message.chat.id, text: 'Локацию сюды э: ', reply_markup: markup)
			end	
		when 'location_of_problem'
			if session[:parameters][:latitude] == nil
				unless message.location.nil?
					session[:parameters][:latitude] = message.location.latitude 
					session[:parameters][:longitude] = message.location.longitude

					session[:status_of_problem] = 'images_of_problem'
					bot.api.send_message(chat_id: message.chat.id, text: 'Отправте изображения проблемы, когда закончите, напишите /end')
				end	
			end	
		when 'images_of_problem'  	
			Dir.mkdir("./pictures/#{message.chat.id}") unless File.exists?("./pictures/#{message.chat.id}/")

			file = bot.api.get_file(file_id: message.photo[2].file_id)
			file_path = file.dig('result', 'file_path')
			photo_url = "https://api.telegram.org/file/bot#{TOKEN}/#{file_path}"
			File.write("./pictures/#{message.chat.id}/image_#{message.message_id}.jpg", open(photo_url).read)
		end
	end	
end	































