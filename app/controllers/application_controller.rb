class ApplicationController < ActionController::API
	before_filter :ensure_authenticated_user

	# Renders a 401 status code if the current user is not authorized
	def ensure_authenticated_user
		head :unauthorized unless current_user
	end

	# Returns the session associated with the access token if available
	def current_session
		@current_session ||= Session.find_by_token token
	end

	# Returns the user associated with the current session if available
	def current_user
		@current_user ||= current_session.present? ? current_session.user : nil
	end

	def token
		bearer = request.headers["HTTP_AUTHORIZATION"]
		bearer ||= request.headers["rack.session"].try(:[], 'Authorization')
		if bearer.present? 
			bearer.split.last
		elsif params[:token]
			params[:token]
		else
			nil
		end
	end

end