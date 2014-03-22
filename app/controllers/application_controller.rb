class ApplicationController < ActionController::API
	include ActionController::ImplicitRender
	include ActionController::MimeResponds

	def cors_preflight_check
		headers['Access-Control-Max-Age'] = '1728000'
		render json: {} # Render as you need
	end

	before_action :ensure_authenticated_user

	# Renders a 401 status code if the current user is not authorized
	def ensure_authenticated_user
		head :unauthorized unless current_user
	end

	# Returns the user associated with the access token if available
	def current_user
		@current_user ||= User.find_by token: get_token
	end

	# Parses the access token from the header
	def get_token
		bearer = request.headers["HTTP_AUTHORIZATION"]

		# allows tests to pass
		bearer ||= request.headers["rack.session"].try(:[], 'Authorization')

		if bearer.present?
			bearer.split.last
		else
			nil
		end
	end
end