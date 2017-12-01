module MessagesHelper
	def panel_type(message)
		case message.status
		when "new_message"
			return "info"
		when "actual"
			return "warning"
		when "done"
			return "success"
		when "not_relevant"
			return "default"
		else
			return "primary"
		end
	end

end
