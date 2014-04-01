class ActivationqueuesController < ApplicationController

	def create
		if Activationqueue.empty?
			Activationqueue.create << current_user
		else
			Activationqueue.first << current_user
		end
		current_user.activate
		Huntsholefiller.new.run
	end

end
