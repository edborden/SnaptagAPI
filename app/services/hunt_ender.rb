class HuntEnder

	def initialize(hunt)
		@hunt = hunt
		@stalker = hunt.stalker
		@target = hunt.target
	end

	def found_target

		# hunt

		@hunt.active = false
		@hunt.completed_at = Time.now
		@hunt.lat = @stalker.lat
		@hunt.lng = @stalker.lng
		@hunt.stealth_stolen = @target.stealth

		# stalker

		@stalker.targets_found_count += 1
		@stalker.stealth += @target.stealth
		@stalker.targets_count -= 1

		# target

		@target.found_count += 1
		@target.stalkers_count -= 1
		@target.stealth = 0

		# save

		@hunt.save
		@stalker.save
		@target.save

		# deactivate

		@target.deactivate

		# notifications

		target_body = "You're Stalker found you! You've been removed from the game."
		@target.notify "Found",target_body,nil
		json_package = NotificationSerializer.new @target.first_notif, scope:@target
		Pusher.trigger @target.id,"notification",json_package
		stalker_body = "Hunt completed successfully!"
		@stalker.notify "Target Found",stalker_body,nil
	end

	def expose

		# hunt

		@hunt.active = false
		@hunt.was_exposed = true
		@hunt.completed_at = Time.now
		@hunt.lat = @target.lat
		@hunt.lng = @target.lng
		@hunt.stealth_stolen = @stalker.stealth

		# target

		@target.stalkers_exposed_count += 1
		@target.stalkers_count -= 1
		@target.stealth += @stalker.stealth

		# stalker

		@stalker.exposed_count += 1
		@stalker.stealth = 0
		@stalker.targets_count -= 1

		# save

		@hunt.save
		@stalker.save
		@target.save

		# deactivate

		@stalker.deactivate		

	end

end