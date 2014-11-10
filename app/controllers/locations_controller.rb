class LocationsController < ApplicationController

	def create
		location = current_user.locations.create params.require(:location).permit(:lat,:lng)
		render json: location
	end

end
