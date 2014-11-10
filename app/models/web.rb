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

end