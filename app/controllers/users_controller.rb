class UsersController < ApplicationController
	skip_before_action :ensure_authenticated_user, only: :login

	def login
		facebook ||= Facebook.new(params[:token])
		token = facebook.exchange_token
		profile = facebook.get_profile
		user = User.find_by(facebookid: profile["id"])

		if user == nil
			if profile
				User.create_from_facebook(token,profile)
				render text: token
			else
				head :unauthorized
			end
		else
			user.set_token(token)
			render text: token
		end
	end

	def me
		render json: @current_user
	end

	def status
		if @current_user.active? && @current_user.activationqueue_id.present?
			render text: "queue" 
		elsif @current_user.active?
			render text: "active"
		else 
			render text: "inactive"
		end
	end

	def find
		if params[:web]
			Websholefiller.new(@current_user).run
			web = @current_user.givers + @current_user.receivers
			render json: web
		end
	end

end