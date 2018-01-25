require 'rest-client'

class Session
	attr_reader   :chat_id
	attr_accessor :status, :text, :images, :text, :address, :latitude, :longitude, :check_address, :check_validation

	def initialize(chat_id, sender_name, sender_id)
		@chat_id   = chat_id
		@text      = ""
		@address   = nil
		@latitude  = nil
		@longitude = nil
		@images    = []
		@check_address = nil
		@check_validation = nil
		@sender_name = sender_name
		@sender_id = sender_id
	end

	def send_parameters
		response = RestClient.post('http://localhost:3000/messages',
		{  :message => {
				 category_id: 1,
				 longitude:   @longitude,
				 latitude:    @latitude,
				 address:     @address,
				 status:     'for_moderation',
				 body:        @text,
				 sender_name: @sender_name,
				 sender_id:   @sender_id },
		})

		message_id = response.body

		@images.each do |image|
			RestClient.post("http://localhost:3000/messages/#{message_id}/image", :image => image)
		end
	end
end

