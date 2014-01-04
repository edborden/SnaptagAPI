class ActivationqueuesController < ApplicationController

	def create
		current_user.active = true
		if Activationqueue.exists?
			activationqueue = Activationqueue.first
			current_user.activationqueue_id = activationqueue.id 
			current_user.save
			if activationqueue.full?
				Blastoff.new(activationqueue) 
				activationqueue.destroy
			end
		else 
			activationqueue = Activationqueue.create
			current_user.activationqueue_id = activationqueue.id
			current_user.save			
		end
		redirect_to root_path
	end
end
