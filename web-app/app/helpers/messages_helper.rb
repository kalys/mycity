module MessagesHelper
	def panel_type(message)
		panel_type =
			case message.status
			when "new_message"
				"info"
			when "actual"
				"warning"
			when "done"
				"success"
			when "not_relevant"
				"default"
			else
				"primary"
			end
	end

end
