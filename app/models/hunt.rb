class Hunt < ActiveRecord::Base
	belongs_to :stalker, class_name: "User"
	belongs_to :target, class_name: "User"

	after_create :plus_one, :ensure_matching_web
	before_destroy :minus_one

	scope :completed, -> {where(active: false)}

	def ensure_matching_web
		if !matching_web
			stalker.make_room
			target.make_room
			if stalker.receivers_count <= target.receivers_count
				giver = stalker
				receiver = target
			else
				giver = target
				receiver = stalker
			end
			Web.create(giver_id: giver.id, receiver_id: receiver.id)
		end
	end

	def matching_web
		Web.find_by(giver_id: self.stalker_id, receiver_id: self.target_id) || Web.find_by(giver_id: self.target_id, receiver_id: self.stalker_id)
	end

	def plus_one
		stalker.increment! :targets_count
		target.increment! :stalkers_count
	end

	def minus_one
		# when deactivated, counts get set to 0, don't need to decrement
		if self.active
			stalker.decrement! :targets_count
			target.decrement! :stalkers_count
		end
	end

end