# only used for inserting new players into the game
# @players is an ActiveRecord User Collection
# @fillers is a vanilla array of new players
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
				lucky_player.activationqueue.users.delete lucky_player
				WebsHoleFiller.new(lucky_player).run
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
		# adding a shuffle here, otherwise always gets the same player for both target/stalker
		target = @players.need_stalkers.shuffle.first
		stalker = @players.need_targets.shuffle.first
		Hunt.create stalker_id: lucky_player.id, target_id: target.id
		to_notify = Hunt.create stalker_id:stalker.id, target_id:lucky_player.id
		to_notify.notify_stalker

	end

end