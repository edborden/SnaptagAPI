class Web < ActiveRecord::Base
	belongs_to :giver, :class_name => "User"
	belongs_to :receiver, :class_name => "User"

	after_create :plus_one 
	before_destroy :minus_one

	def matching_hunt
		Hunt.find_by(stalker_id: self.giver_id, target_id: self.receiver_id) || Hunt.find_by(stalker_id: self.receiver_id, target_id: self.giver_id)
	end

	def plus_one
		giver.increment!(:receivers_count)
		receiver.increment!(:givers_count)
	end

	def minus_one
		giver.decrement!(:receivers_count)
		receiver.decrement!(:givers_count)
	end

	def remove_suspects
		giver.remove_suspect receiver
		receiver.remove_suspect giver
	end

	def push
		json_package = SuspectSerializer.new giver, scope:receiver, root:'user'
		Pusher.trigger "user"+receiver.id.to_s,'New suspect',json_package
		json_package = SuspectSerializer.new receiver, scope:giver, root:'user'
		Pusher.trigger "user"+giver.id.to_s,'New suspect',json_package
	end

end