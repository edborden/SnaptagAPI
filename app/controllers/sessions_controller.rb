class SessionsController < ApplicationController
	skip_before_action :ensure_authenticated_user, only: :index

	def index
		session = Session.find_by_token params[:token]
		unless session
			facebook ||= Facebook.new params[:token]
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
		else
			user = session.user
		end
		WebsHoleFiller.new(user).run if user.active
		render json: [session], scope: user
	end

	def destroy
		current_user.session.destroy
		head :ok
	end

end
