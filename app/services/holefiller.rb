class Holefiller

	def run
		if it_is_time?
			lucky_user = get_new_player
			fill_hunt_holes(lucky_user)
		end
	end

	def it_is_time?
		if User.need_hunters.count >= 3 && User.need_targets.count >= 3
			## Can't fill holes if no one is waiting to fill them
			return true if Activationqueue.all.empty? == false
		end
		return false
	end

	def get_new_player
		lucky_user = Activationqueue.first.users.shuffle.first
		return lucky_user
	end

	def fill_hunt_holes(lucky_user)
      targets = User.need_hunters.shuffle.take(3)
      hunters = User.need_targets.shuffle.take(3)
      targets.each {|target| Hunt.create(hunter_id:lucky_user.id,target_id:target.id)}
      hunters.each {|hunter| Hunt.create(hunter_id:hunter.id,target_id:lucky_user.id)}
    end

end