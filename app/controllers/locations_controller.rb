class LocationsController < ApplicationController

	def update
		Location.create_from_client(@current_user,params)
		@current_user.increment!(:influence)
		render :ok
	end

end
