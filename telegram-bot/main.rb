require 'telegram/bot'

TOKEN = '499660598:AAF-INPO3WiMq2DfO7KFLyfgMrUlpi9RvVQ'

Telegram::Bot::Client.run(TOKEN) do |bot|
	bot.listen do |message|
		case message.text
		when '/start', '/start start'
			bot.api.send_message(
				chat_id: message.chat.id,
				text: "Привет, #{message.from.first_name}"
				)
		else
			bot.api.send_message(
				chat_id: message.chat.id,
				text: "Чёё?!"
				)
		end			
	end	
end	