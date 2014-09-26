class SessionsController < ApplicationController
	skip_before_action :ensure_authenticated_user, except: :destroy

	def create
		facebook = Facebook.new params[:session][:token]
		token = facebook.exchange_token
		profile = facebook.get_profile
		user = User.find_by_facebookid profile["id"]
		user = User.create_from_facebook token,profile unless user
		WebsHoleFiller.new(user).run if user.active
		user.session.destroy if user.session.present?
		session = user.create_session token: token		
		render json: session, scope: user
	end

	def index
		session = Session.find_by_token params[:token]
		if session
			user = session.user
			WebsHoleFiller.new(user).run if user.active
			render json: [session], scope: user
		else
			head :unauthorized
		end
	end

	def destroy
		current_user.session.destroy
		head :ok
	end

end
