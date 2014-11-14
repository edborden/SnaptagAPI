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

		# notify targets' other stalkers

		body = "Your target, " + @target.name + ", was found by another Stalker."
		@target.stalkers.each do |stalker|
			stalker.notify "Target removed",body,@target
			json_package = NotificationSerializer.new stalker.first_notif, scope:stalker
			Pusher.trigger stalker.id,'notification',json_package
		end

		# notify target

		body = "Your Stalker, " + @stalker.name + ", found you! You've been removed from the game."
		@target.notify "Found",body,nil
		json_package = NotificationSerializer.new @target.first_notif, scope:@target
		Pusher.trigger @target.id,"notification",json_package

		# notify stalker - notification gets push out via controller

		body = "Hunt completed successfully!"
		@stalker.notify "Target Found",body,nil

		# deactivate

		@target.deactivate

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

		# notify stalker's stalkers

		body = "Your target, " + @stalker.name + ", was exposed by one of their targets."
		@stalker.stalkers.each do |stalker|
			# handle when target is also stalker, so they don't get two messages
			unless stalker == @target
				stalker.notify "Target removed",body,@stalker
				json_package = NotificationSerializer.new stalker.first_notif, scope:stalker
				Pusher.trigger stalker.id,'notification',json_package
			end
		end

		# notify stalker

		body = "Your target, " + @target.name + ", exposed you! You've been removed from the game."
		@stalker.notify "Exposed",body,nil
		json_package = NotificationSerializer.new @stalker.first_notif, scope:@stalker
		Pusher.trigger @stalker.id,"notification",json_package

		# notify target - notification gets push out via controller

		body = "You exposed your stalker!"
		@target.notify "Stalker exposed",body,nil

		# deactivate

		@stalker.deactivate		

	end

end