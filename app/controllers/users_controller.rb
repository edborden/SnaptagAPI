class UsersController < ApplicationController
	skip_before_action :ensure_authenticated_user, only: :login

	def login

		user = User.find_by(facebookid: params[:facebookid])

		## if new user:
		### create user
		if user == nil
			if Facebook.new.verify_token?(params[:facebookid],params[:token])
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
		elsif Facebook.new.verify_token?(user.facebookid,params[:token])
			user.set_token(params[:token])
			render json: {}
		else
			head :unauthorized
		end

	end

	def me
		render json: @current_user
	end

end