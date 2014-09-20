class Hunt < ActiveRecord::Base
	belongs_to :hunter, class_name: "User"
	belongs_to :target, class_name: "User"

	after_create :plus_one, :ensure_matching_web
	before_destroy :minus_one

	scope :completed, -> {where(active: false)}

	def ensure_matching_web
		if !matching_web
			make_room(hunter)
			make_room(target)
			if hunter.receivers_count <= target.receivers_count
				giver = hunter
				receiver = target
			else
				giver = target
				receiver = hunter
			end
			Web.create(giver_id: giver.id, receiver_id: receiver.id)
		end
	end

	def make_room(user)
		user.remove_nonhunt_web until user.reload.allwebs_count < 11
	end

	def matching_web
		Web.find_by(giver_id: self.hunter_id, receiver_id: self.target_id) || Web.find_by(giver_id: self.target_id, receiver_id: self.hunter_id)
	end

	def plus_one
		hunter.increment! :targets_count
		target.increment! :hunters_count
	end

	def minus_one
		# when deactivated, counts get set to 0, don't need to decrement
		if self.active
			hunter.decrement! :targets_count
			target.decrement! :hunters_count
		end
	end

end