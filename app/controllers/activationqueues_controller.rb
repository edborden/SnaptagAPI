class ActivationqueuesController < ApplicationController

	def create
		activationqueue = Activationqueue.create
		activationqueue.users<<(current_user)
		current_user.active = true
		current_user.save
		redirect_to root_path	
	end

	def update
		activationqueue = Activationqueue.first
		activationqueue.users<<(current_user)
		current_user.active = true
		current_user.save
		redirect_to root_path
	end
end
