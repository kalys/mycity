require 'rest-client'

class Session
	attr_reader :chat_id
	attr_accessor :status, :text, :images, :text, :address, :latitude, :longitude, :send_p

	def initialize(chat_id)
		@chat_id   = chat_id
		@status    = nil
		@text      = nil
		@address   = nil
		@latitude  = nil
		@longitude = nil
		@images    = []
	  @send_p    = false
	end

	def send_parameters(url)
		response = RestClient.post(url + 'messages',
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
			RestClient.post(url + "messages/#{message_id}/image", :image => image)
		end

		initialize(@chat_id)
	end
end

