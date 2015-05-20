class HuntsController < ApplicationController

	def expose

		head :no_content

		hunt = Hunt.find_by(stalker_id: params[:stalker_id], target_id: @current_user.id, active: true)
		if hunt
			HuntEnder.new(hunt).expose
		else
			current_user.expose_self
		end
	end

	def found_target

		head :no_content

		hunt = Hunt.find_by(stalker_id: @current_user.id, target_id: params[:target_id])
		HuntEnder.new(hunt).found_target
	end

	def join

		head :no_content
		Join.new current_user,params.require(:location).permit(:lat,:lng)

	end

	def unjoin
		
		head :no_content

		Pusher.trigger "activationqueue"+current_user.activationqueue.id.to_s,"Remove user from activationqueue",current_user.id
		current_user.activationqueue.users.delete current_user
		current_user.deactivate


	end

	#def intro_map
	#	render json: Hunt.completed, each_serializer: HuntLocationOnlySerializer
	#end

end
