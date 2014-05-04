class Hunt < ActiveRecord::Base
	belongs_to :hunter, :class_name => "User"
	belongs_to :target, :class_name => "User"

	after_create :plus_one, :ensure_matching_web
	before_destroy :minus_one

	scope :completed, -> {where(active: false)}

	def complete
		self.active = false
		self.completed_at = Time.now
		if self.counteracted
			location = target.latest_location
		else
			location = hunter.latest_location
		self.latitude = location.latitude
		self.longitude = location.longitude
		save
		appropriate_influence
		minus_one
	end

	def success
		complete
		target.compromise
		hunter.performed_successful_hunt
	end

	def appropriate_influence
		if self.counteracted
			self.influence_appropriated = hunter.influence
			save
			target.add_influence(hunter.influence)
			hunter.wipe_influence
		else
			self.influence_appropriated = target.influence
			save
			hunter.add_influence(target.influence)
			target.wipe_influence

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
		hunter.increment!(:targets_count)
		target.increment!(:hunters_count)
	end

	def minus_one
		hunter.decrement!(:targets_count)
		target.decrement!(:hunters_count)
	end

	def counteract
		self.counteracted = true
		save
		complete
		hunter.compromise
		target.performed_counteraction
	end

end
