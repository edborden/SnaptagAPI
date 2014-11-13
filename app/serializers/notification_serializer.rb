class NotificationSerializer < ApplicationSerializer
	attributes :read, :subject, :body, :created_at, :notified_object_type, :notified_object_id
	
	def read
		object.is_read?(scope)
	end
end
