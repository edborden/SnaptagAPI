class ActivationqueuesController < ApplicationController

	def create
		if Activationqueue.empty?
			activationqueue = Activationqueue.create.add_user(current_user)
		else
			activationqueue = Activationqueue.first.add_user(current_user)
		end
		current_user.activate
		Holefiller.new.run
	end

end
