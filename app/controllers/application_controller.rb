class ApplicationController < ActionController::API
	before_filter :ensure_authenticated_user
	before_filter :cors_preflight_check
	after_filter :cors_set_access_control_headers

	# For all responses in this controller, return the CORS access control headers.

	def cors_set_access_control_headers
		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
		headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With Authorization X-CSRF-Token}.join(',')
		headers['Access-Control-Max-Age'] = "1728000"
	end

	def cors_preflight_check
		if request.method == "OPTIONS"
			headers['Access-Control-Allow-Origin'] = '*'
			headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
			headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With Authorization X-CSRF-Token}.join(',')
			headers['Access-Control-Max-Age'] = '1728000'
			render :text => '', :content_type => 'text/plain'
		end
	end

	# Renders a 401 status code if the current user is not authorized
	def ensure_authenticated_user
		head :unauthorized unless current_user or request.method == "OPTIONS"
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