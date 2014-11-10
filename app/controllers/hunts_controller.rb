class HuntsController < ApplicationController

	def expose
		hunt = Hunt.find_by(stalker_id: params[:stalker_id], target_id: @current_user.id, active: true)
		if hunt
			HuntEnder.new(hunt).expose
			render text: "success"
		else
			@current_user.expose_self
			render text: "failure"
		end
	end

	def found_target
		hunt = Hunt.find_by(stalker_id: @current_user.id, target_id: params[:target_id])
		HuntEnder.new(hunt).found_target
		render text: "success"
	end

	def join
		current_user.locations.create params.require(:location).permit(:lat,:lng)
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

	#def intro_map
	#	render json: Hunt.completed, each_serializer: HuntLocationOnlySerializer
	#end

end
