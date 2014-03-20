class ApplicationController < ActionController::API

  # Renders a 401 status code if the current user is not authorized
  def ensure_authenticated_user
    head :unauthorized unless current_user
  end

  # Returns the user associated with the access token if available
  def current_user
    current_user ||= User.find_by(token: token)
  end

  # Parses the access token from the header
  def token
    bearer = request.headers["HTTP_AUTHORIZATION"]

    # allows our tests to pass
    bearer ||= request.headers["rack.session"].try(:[], 'Authorization')

    if bearer.present?
      bearer.split.last
    else
      nil
    end
  end
end