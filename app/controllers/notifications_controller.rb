class NotificationsController < AuthenticatedController

	def update
		notification = Mailboxer::Notification.find params[:id]
		notification.mark_as_read current_user if params[:notification][:read] == true
		render json: notification.reload
	end

end