class ActivationqueuesController < AuthenticatedController

	def show
		activationqueue = Activationqueue.find params[:id]
		render json: activationqueue
	end

end