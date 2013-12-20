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
		count = 0
		userlist = queue.users.shuffle
		userlist << userlist[0] << userlist[1] << userlist[2]
		userlist.each do |u|
			if count < 13
				Relationship.create(:user_id => u.id, :relation_id => userlist[(count + 1)].id, :relationship_type => :hunt)
				Relationship.create(:user_id => u.id, :relation_id => userlist[(count + 2)].id, :relationship_type => :hunt)
				Relationship.create(:user_id => u.id, :relation_id => userlist[(count + 3)].id, :relationship_type => :hunt)
				count = count + 1
			end
		end
		queue.destroy
	end	

end
