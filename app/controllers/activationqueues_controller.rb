class ActivationqueuesController < ApplicationController

	def show
		activationqueue = Activationqueue.find params[:id]
		render json: activationqueue
	end

end