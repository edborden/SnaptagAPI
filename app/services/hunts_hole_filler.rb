class HuntsHoleFiller

	def run
		if it_is_time?
			fill_hunt_holes lucky_player
			lucky_player.activationqueue_id = nil
			lucky_player.save
		end
	end

	def it_is_time?
		User.need_stalkers.count >= 3 && User.need_targets.count >= 3 && Activationqueue.exists?
	end

	def lucky_player
		@lucky_player ||= Activationqueue.first.users.shuffle.first
	end

	def fill_hunt_holes(lucky_player)
		targets = User.need_stalkers.take(3)
		stalkers = User.need_targets.take(3)
		targets.each {|target| Hunt.create(stalker_id:lucky_player.id,target_id:target.id)}
		stalkers.each do |stalker| 
			Hunt.create(stalker_id:stalker.id,target_id:lucky_player.id)
			json_package = SuspectSerializer.new lucky_player, scope:stalker
			Pusher.trigger stalker.id,"new_target",json_package
		end
	end

end