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
		@target.stalkers.each {|stalker| stalker.notify "Target removed",body,@target}

		# notify target

		body = "Your Stalker, " + @stalker.name + ", found you! You've been removed from the game."
		@target.notify "Found",body,nil

		# notify stalker

		@stalker.notify "Target Found","Hunt completed successfully!",nil

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
		# handle when target is also stalker, so they don't get two messages

		body = "Your target, " + @stalker.name + ", was exposed by one of their targets."
		@stalker.stalkers.each {|stalker| stalker.notify "Target removed",body,@stalker unless stalker == @target}

		# notify stalker

		body = "Your target, " + @target.name + ", exposed you! You've been removed from the game."
		@stalker.notify "Exposed",body,nil

		# notify target
 
		@target.notify "Stalker exposed","You exposed your stalker!",nil

		# deactivate

		@stalker.deactivate		

	end

end