class SessionsController < ApplicationController
	skip_before_action :ensure_authenticated_user, only: :show

	def show
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
		user.session.destroy if user.session.present?
		session = user.create_session token: token
		render json: session
	end

	def destroy
		current_user.session.destroy
		head :ok
	end

end
