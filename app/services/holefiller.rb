class Holefiller

	def run
		fill_hunt_holes(lucky_player) if it_is_time?
	end

	def it_is_time?
		true if User.need_hunters.count >= 3 and User.need_targets.count >= 3 and Activationqueue.all.empty? == false
	end

	def lucky_player
		Activationqueue.first.users.shuffle.first
	end

	def fill_hunt_holes(lucky_player)
		targets = User.need_hunters.shuffle.take(3)
		hunters = User.need_targets.shuffle.take(3)
		targets.each {|target| Hunt.create(hunter_id:lucky_player.id,target_id:target.id)}
		hunters.each {|hunter| Hunt.create(hunter_id:hunter.id,target_id:lucky_player.id)}
	end

end