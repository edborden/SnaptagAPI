class NotificationSerializer < ApplicationSerializer
	attributes :read, :subject, :body, :created_at
	
	def read
		object.is_read?(scope)
	end
end
