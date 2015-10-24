class HuntsHoleFiller

	def run
		if it_is_time?
			fill_hunt_holes lucky_player
			lucky_player.activationqueue_id = nil
			lucky_player.save
			lucky_player.notify_entered_game
		end
	end

	def it_is_time?
		User.need_stalkers.count >= 3 && User.need_targets.count >= 3 && Activationqueue.exists?
	end

	def lucky_player
		@lucky_player ||= Activationqueue.first.users.shuffle.first ## REFACTOR WITH http://hashrocket.com/blog/posts/rails-quick-tips-random-records
	end

	def fill_hunt_holes(lucky_player)
		targets = User.need_stalkers.take(3)
		stalkers = User.need_targets.take(3)
		targets.each {|target| Hunt.create(stalker_id:lucky_player.id,target_id:target.id)}
		stalkers.each do |stalker| 
			Hunt.create(stalker_id:stalker.id,target_id:lucky_player.id)
			json_package = SuspectSerializer.new lucky_player, scope:stalker, root:'user'
			Pusher.trigger "user"+stalker.id.to_s,"New target",json_package
			stalker.notify "New target added","Get moving!",nil	
		end
	end

end