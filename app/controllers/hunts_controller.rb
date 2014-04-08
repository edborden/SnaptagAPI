class HuntsController < ApplicationController

	def update
		if params[:hunter_id] # it's a counteraction
			hunt = Hunt.find_by(hunter_id: params[:hunter_id], target_id: @current_user.id, active: true).exists?
			if hunt.exists?
				hunt.counteract
				render text: "success"
			else
				user.disavow
				render text: "disavowed"
			end
		else #it's a hunt completion
			hunt = Hunt.find(params[:hunt_id])
			hunt.complete
			render :ok
		end
	end

end