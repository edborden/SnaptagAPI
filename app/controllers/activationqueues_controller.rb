class ActivationqueuesController < RelationshipsController

	def create
		if Activationqueue.exists?
			@queue = Activationqueue.first
			current_user.activationqueue_id = @queue.id 
			@queue.check_full
		else 
			@queue = Activationqueue.build
			current_user.activationqueue_id = @queue.id
		end
	end

	private

	def check_full
		blast_off(@queue) if @queue.full?
	end	

	def blast_off(userlist)
		userlist.each do |u|
			user
		end
	end	

end
