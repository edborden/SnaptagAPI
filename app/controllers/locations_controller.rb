class LocationsController < ApplicationController

	def update
		Location.create_from_client(@current_user,params)
		@current_user.increment!(:influence)
		render text: "ok"
	end

	def find
		if params[:target_locations]
			locations_response = []
			if @current_user.targets.exists?
				@current_user.targets.each do |target|
					locations_response += [target.locations]
				end
			end
			render json: locations_response
		end
	end

end
