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
		response = RestClient.post('http://localhost:3000/messages',
		{  :message => {
				 category_id: 1,
				 longitude:   @longitude,
				 latitude:    @latitude,
				 address:     @address,
				 status:     'new_message',
				 body:        @text },
		})

		message_id = response.body

		@images.each do |image|
			RestClient.post("http://localhost:3000/messages/#{message_id}/image", :image => image)
		end

		initialize(@chat_id)
	end
end

