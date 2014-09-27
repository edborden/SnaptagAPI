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
		current_user.locations.create params.require(:location).permit(:lat,:lon)
		current_user.activate
		current_user.reload
		########
		########
		Demo.new.create_activationqueue_around current_user
		########
		########
		queue = Activationqueue.find_by(zone_id: current_user.zone_id) || Activationqueue.create(zone_id: current_user.zone_id)
		queue.users<<current_user
		HuntsHoleFiller.new.run
		render json: current_user.reload, serializer: MeSerializer, root: 'user'
	end

	def intro_map
		render json: Hunt.completed, each_serializer: HuntLocationOnlySerializer
	end

end
