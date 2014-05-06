class HuntEnder

	def initialize(hunt)
		@hunt = hunt
		@hunter = hunt.hunter
		@target = hunt.target
	end

	def expose_success

		# hunt

		@hunt.active = false
		@hunt.completed_at = Time.now
		@hunt.latitude = @hunter.latest_location.latitude
		@hunt.longitude = @hunter.latest_location.longitude
		@hunt.influence_appropriated = @target.influence

		# hunter

		@hunter.exposed_count += 1
		@hunter.influence += @target.influence
		@hunter.targets_count -= 1

		# target

		@target.compromised_count += 1
		@target.hunters_count -= 1
		@target.influence = 0

		# save

		@hunt.save
		@hunter.save
		@target.save

		# deactivate

		@target.deactivate

	end

	def counteract_success

		# hunt

		@hunt.active = false
		@hunt.counteracted = true
		@hunt.completed_at = Time.now
		@hunt.latitude = @target.latest_location.latitude
		@hunt.longitude = @target.latest_location.longitude
		@hunt.influence_appropriated = @hunter.influence

		# target

		@target.compromised_count += 1
		@target.hunters_count -= 1
		@target.influence = @hunter.influence

		# hunter

		@hunter.exposed_count += 1
		@hunter.influence = 0
		@hunter.targets_count -= 1

		# save

		@hunt.save
		@hunter.save
		@target.save

		# deactivate

		@hunter.deactivate		

	end

end