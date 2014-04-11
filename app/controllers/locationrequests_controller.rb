class LocationrequestsController < ApplicationController

	def locate
		if @current_user.targets.include?(params[:target_id])
			target = User.find(:target_id)
			target.location.create_locationrequest(requester_id: @current_user.id)
		end
	end

end
