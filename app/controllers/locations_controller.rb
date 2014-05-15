class LocationsController < ApplicationController

	def update
		Location.create_from_client(@current_user,params[:latitude],params[:longitude],params[:accuracy],params[:timestamp])
		@current_user.increment!(:influence)
		render text: "ok"
	end

end
