class SessionsController < ApplicationController
	skip_before_action :ensure_authenticated_user, only: :show

	def show
		session = Session.find_by_token params[:id]
		if session
			render json: session
		else
			facebook ||= Facebook.new params[:id]
			token = facebook.exchange_token
			profile = facebook.get_profile
			user = User.find_by_facebookid profile["id"]

			unless user
				if profile
					user = User.create_from_facebook token,profile
				else
					head :unauthorized
				end
			end
			session = user.create_session token: token
			render json: session
		end
	end

	def destroy
		current_user.session.destroy
		head :ok
	end

end
