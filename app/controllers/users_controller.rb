class UsersController < ApplicationController
	skip_before_action :ensure_authenticated_user, only: :create
	# login:
	def create

		user = User.find_by(facebookid: params[:facebookid])

		## if new user:
		### exchange for 60 day token
		### create user, return user

		if user == nil
			new_token = Facebook.new.exchange_token(params[:token])
			user = User.create_from_facebook(new_token)
			render json: {}, status: 200

		## if existing user
		### if tokens match, return user
		### if tokens don't match, exchange for 60 day token, return user

		elsif user.token == params[:token]
			render json: {}, status: 200

		else
			user.token = Facebook.new.exchange_token(params[:token])
			user.save
			render json: {}, status: 200
		end

	end

	def me
		render json: current_user
	end

end