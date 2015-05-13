class ApplicationController < ActionController::API
	before_filter :ensure_authenticated_user

	# Renders a 401 status code if the current user is not authorized
	def ensure_authenticated_user
		head :unauthorized unless params[:inactive_map] || current_user
	end

	# Returns the user associated with the access token if available
	def current_user
		@current_session ||= Session.find_by(token: token)
		@current_user ||= @current_session.present? ? @current_session.user : nil
	end

	def token
		bearer = request.headers["HTTP_AUTHORIZATION"]
		bearer ||= request.headers["rack.session"].try(:[], 'Authorization')
		bearer.present? ? bearer.split.last : nil
	end

end