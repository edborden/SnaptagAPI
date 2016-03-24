class WebsHoleFiller

	def initialize(user)
		@user = user
		@zone = user.zone
		@allwebs_count = @user.allwebs_count
		@receivers_count = @user.receivers_count
		@givers_count = @user.givers_count
		@need_givers = @zone.users.need_givers - [@user.givers] - [@user]
		@need_receivers ||= @zone.users.need_receivers - [@user.receivers] - [@user]
	end

	def run
		fill_web_hole until time_to_stop?
	end

	def time_to_stop?
		true if @allwebs_count >= 11 || (@need_givers.blank? && @need_receivers.blank?)
	end

	def fill_web_hole
		if giver? && @need_givers.present?
			receiver = @need_givers.shift
			@need_receivers.delete receiver
			web = Web.create(giver_id: @user.id, receiver_id: receiver.id)
			@receivers_count += 1
		else
			giver = @need_receivers.shift
			@need_givers.delete giver
			web = Web.create(giver_id: giver.id, receiver_id: @user.id)
			@givers_count += 1
		end
		@allwebs_count += 1
		web.push
	end

	def giver?
		@givers_count <= @receivers_count
	end

end