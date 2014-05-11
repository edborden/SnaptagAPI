class UsersController < ApplicationController
	skip_before_action :ensure_authenticated_user, only: :login
	skip_before_action :ensure_authenticated_user, only: :intro_map

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
		if params[:web_without_targets]
			WebsHoleFiller.new(@current_user).run
			web_without_targets = @current_user.givers + @current_user.receivers - @current_user.targets
			render json: web_without_targets
		elsif params[:targets]
			render json: @current_user.targets, each_serializer: UserWithLocationsSerializer
		elsif params[:intro_map]
			render json: User.active, each_serializer: IntroMapUserSerializer
		end
	end

end