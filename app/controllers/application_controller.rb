class ApplicationController < ActionController::API
	before_filter :ensure_authenticated_user

	# Renders a 401 status code if the current user is not authorized
	def ensure_authenticated_user
		head :unauthorized unless params[:intro_map] || current_user
	end

	# Returns the user associated with the access token if available
	def current_user
		@current_user ||= User.find_by token: params[:token]
	end

end