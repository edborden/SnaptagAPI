class UsersController < ApplicationController
	skip_before_action :ensure_authenticated_user, only: :login

	def login
		facebook ||= Facebook.new(params[:token])
		token = facebook.exchange_token
		profile = facebook.get_profile
		user = User.find_by(facebookid: profile["id"])

		if user == nil
			if profile
				user = User.create_from_facebook(token,profile)
				render json: {token: token, status: user.status}
			else
				head :unauthorized
			end
		else
			user.set_token(token)
			render json: {token: token, status: user.status}
		end
	end

	def me
		render json: @current_user
	end

	def user_status
		render text: @current_user.status
	end

	def find
		if params[:web_without_targets]
			WebsHoleFiller.new(@current_user).run
			web_without_targets = @current_user.givers + @current_user.receivers - @current_user.targets
			render json: web_without_targets
		elsif params[:targets]
			render json: @current_user.targets
		elsif params[:targets_with_locations]
			render json: @current_user.targets, each_serializer: UserWithLocationsSerializer
		elsif params[:inactive_map]
#			Demo.new.users_around(params[:lat].to_f,params[:lon].to_f)
			nearest_zone = Zone.determine_nearest_zone_for(params[:lat].to_f,params[:lon].to_f)
			# if no zones within 30 miles, render "none"
			if !nearest_zone.within_50km_of params[:lat].to_f,params[:lon].to_f
				render text: "none"
			else
			# If it's in an active zone, show me that zone and its users
				if nearest_zone.active?
					render json: nearest_zone.users, each_serializer: InactiveMapUserSerializer
			# If it's a queue zone, show it + users, and the next zone, until an active zone is reached or 30 miles
				else
					nearest_zones = [nearest_zone]
					until !nearest_zone.within_50km_of(params[:lat].to_f,params[:lon].to_f) || nearest_zone.active?
						nearest_zone = Zone.determine_nearest_zone_for(params[:lat].to_f,params[:lon].to_f,nearest_zones)
						nearest_zones += [nearest_zone]
					end
					users = []
					nearest_zones.each do |zone|
						users += zone.users
					end
					render json: users, each_serializer: InactiveMapUserSerializer
				end
			end
		end
	end

end