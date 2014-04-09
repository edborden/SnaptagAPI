class HuntsController < ApplicationController

	def counteract
		hunt = Hunt.find_by(hunter_id: params[:hunter_id], target_id: @current_user.id, active: true).exists?
		if hunt.exists?
			hunt.counteract
			render text: "success"
		else
			user.disavow
			render text: "disavowed"
		end
	end

	def complete
			hunt = Hunt.find(params[:hunt_id])
			hunt.complete
			render :ok
	end

	def join
		@current_user.activate
		if !Activationqueue.exists?
			queue = Activationqueue.create
			queue.users<<@current_user
		else
			queue = Activationqueue.first
			queue.users<<@current_user
		end
		Huntsholefiller.new.run
		if @current_user.activationqueue_id.present?
			render text: "queue" 
		else 
			render text: "active"
		end
	end

end
