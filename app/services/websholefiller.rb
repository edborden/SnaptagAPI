class Websholefiller

	def run(user)
		fill_web_holes(user) unless (user.reload.givers + user.receivers) > 10
	end

	def fill_web_holes(user)
		if giver_or_receiver(user) == "giver"
			receiver = User.need_givers(user.id).shuffle.take
			Web.create(:giver_id => user.id, :receiver_id => receiver.id)
		else
			giver = User.need_receivers(user.id).shuffle.take
			Web.create(:giver_id => giver.id, :receiver_id => user.id)
		end

	def giver_or_receiver(user)
		if user.givers_count >= user.receivers_count
			return "receiver"
		else
			return "giver"
		end
	end