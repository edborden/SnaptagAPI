class Holefiller

	def run
		if it_is_time?
			lucky_user = get_new_player
			fill_hunt_holes(lucky_user)
		end
	end

	def it_is_time?
		if User.active.need_hunters.count >= 3 && User.active.need_targets.count >= 3
			## Can't fill holes if no one is waiting
			return true if Activationqueue.all.empty? == false
		end
		return false
	end

	def get_new_player
		lucky_user = Activationqueue.first.users.shuffle.take(1)
		return lucky_user
	end

	def fill_hunt_holes(lucky_user)
      targets = User.active.need_hunters.shuffle.take(3)
      hunters = User.active.need_targets.shuffle.take(3)
      targets.each do |target|
        Hunt.create(lucky_user.user_id,target.id)
      end
      hunters.each do |hunter|
        Hunt.create(hunter.id, lucky_user.id)
      end  
    end

end