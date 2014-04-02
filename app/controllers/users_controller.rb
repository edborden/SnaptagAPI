class UsersController < ApplicationController
	skip_before_action :ensure_authenticated_user, only: :login

	def login

		user = User.find_by(facebookid: params[:facebookid])

		## if new user:
		### create user
		if user == nil
			if Facebook.new(params[:token]).verify_token?(params[:facebookid])
				User.create_from_facebook(params[:token])
				render json: {}
			else
				head :unauthorized
			end

		## if existing user
		### if tokens match, return ok
		elsif user.token == params[:token]
			render json: {}

		### there is a matched user, but tokens don't match, verify token
		elsif Facebook.new(params[:token]).verify_token?(params[:facebookid])
			user.set_token(params[:token])
			render json: {}
		else
			head :unauthorized
		end

	end

	def me
		render json: @current_user
	end

	def find
		if params[:web] = true
			Websholefiller.new(@current_user).run
			web = @current_user.givers + @current_user.receivers
			render json: web
	end

end