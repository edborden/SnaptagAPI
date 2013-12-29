class ActivationqueuesController < ApplicationController

	def create
		current_user.active = true
		if Activationqueue.exists?
			@queue = Activationqueue.first
			current_user.activationqueue_id = @queue.id 
			current_user.save
			check_full(@queue)
		else 
			@queue = Activationqueue.create
			current_user.activationqueue_id = @queue.id
			current_user.save			
		end
		redirect_to root_path
	end

	private

	def check_full(queue)
		blast_off(queue) if queue.reload.full?
	end	

	def blast_off(queue)
		userlist = queue.users.shuffle
		@targetslist = userlist
		userlist.each do |user|
			3.times { shuffle_and_relate(user) }
		end
		queue.destroy
	end	

	private

	def shuffle_and_relate(user)
		@targetslist.shuffle
		position = 0
		## target can't be same as hunter and no duplicate targets
		position += 1 until user != @targetslist[position] && user.is_not_already_hunting?(@targetslist[position])

		Relationship.create(:user_id => user.id, :relation_id => @targetslist[position].id, :relationship_type => :hunt)
		
		## check if huntercount is full, then remove from list
		@targetslist -= @targetslist[position] if @targetslist[position].reload.has_enough_hunters? 

	end

end
