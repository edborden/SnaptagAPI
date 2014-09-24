class HuntsController < ApplicationController

	def counteract
		hunt = Hunt.find_by(hunter_id: params[:hunter_id], target_id: @current_user.id, active: true)
		if hunt
			HuntEnder.new(hunt).counteract_success
			render text: "success"
		else
			@current_user.disavow
			render text: "failure"
		end
	end

	def expose
		hunt = Hunt.find_by(hunter_id: @current_user.id, target_id: params[:target_id])
		HuntEnder.new(hunt).expose_success
		render text: "success"
	end

	def join
		########
		########
		Demo.new.create_activationqueue_around params[:lat].to_f,params[:lon].to_f
		########
		########
		current_user.locations.create params.require(:location).permit(:lat,:lon)
		current_user.activate
		unless Activationqueue.exists?
			queue = Activationqueue.create
			queue.users<<@current_user
		else
			queue = Activationqueue.first
			queue.users<<@current_user
		end
		HuntsHoleFiller.new.run
		if current_user.reload.activationqueue_id.present?
			render text: "queue" 
		else 
			render text: "active"
		end
	end

	def intro_map
		render json: Hunt.completed, each_serializer: HuntLocationOnlySerializer
	end

end
