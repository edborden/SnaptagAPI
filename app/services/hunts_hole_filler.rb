class HuntsHoleFiller
	attr_accessor :ran, :lucky_player

	def initialize players, fillers
		@players = players
		@fillers = fillers
	end

	def run
		if it_is_time?
			fill_hunt_hole lucky_player
			if lucky_player.activationqueue_id
				lucky_player.activationqueue.remove_user lucky_player
				WebsHoleFiller(lucky_player).run
				lucky_player.notify_entered_game
			end
			@ran = true
		end
	end

	def it_is_time?
		@players.need_stalkers.count >= 1 && @players.need_targets.count >= 1 && @fillers.present?
	end

	def lucky_player
		@lucky_player ||= @fillers.shuffle.first ## REFACTOR WITH http://hashrocket.com/blog/posts/rails-quick-tips-random-records
	end

	def fill_hunt_hole(lucky_player)
		target = @players.need_stalkers.first
		stalker = @players.need_targets.first
		Hunt.create stalker_id: lucky_player.id, target_id: target.id
		Hunt.create stalker_id:stalker.id, target_id:lucky_player.id
		json_package = SuspectSerializer.new lucky_player, scope:stalker, root:'user'
		Pusher.trigger "user"+stalker.id.to_s,"New target",json_package
		stalker.notify "New target added","Get moving!",nil	
	end

end