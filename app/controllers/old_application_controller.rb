class ApplicationController < ActionController::API
	before_filter :ensure_authenticated_user,:cors_preflight_check

	# Renders a 401 status code if the current user is not authorized
	def ensure_authenticated_user
		if request.method_symbol != :options
			head :unauthorized unless params[:inactive_map] || current_user
		end
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

	def cors_preflight_check
		if request.method_symbol == :options
			headers['Access-Control-Allow-Origin'] = '*'
			headers['Access-Control-Allow-Methods'] = 'POST, GET, DELETE, PUT, PATCH'
			headers['Access-Control-Request-Headers'] = "Accept, Content-Type"
			headers['Access-Control-Allow-Headers'] = "Content-Type,Authorization"
			headers['Access-Control-Max-Age'] = '1728000'
			render :text => '', :content_type => 'text/plain'
		end
	end
end