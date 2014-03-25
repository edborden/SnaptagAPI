class ApplicationController < ActionController::API
	before_filter :ensure_authenticated_user

	# Renders a 401 status code if the current user is not authorized
	def ensure_authenticated_user
		head :unauthorized unless current_user
	end

	# Returns the user associated with the access token if available
	def current_user
		@current_user ||= User.find_by token: params[:token]
		if @current_user == nil
			if Facebook.new.verify_token?(params[:facebookid],params[:token])
				@current_user = User.find_by(facebookid: params[:facebookid])
				@current_user.set_token(params[:token])
		return @current_user


	end

end