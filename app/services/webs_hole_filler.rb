class WebsHoleFiller

	def initialize(user)
		@user = user
	end

	def currently_webbed
		@user.givers + @user.receivers
	end

	def need_givers
		User.need_givers(@user.id) - [currently_webbed]
	end

	def need_receivers
		User.need_receivers(@user.id) - [currently_webbed]
	end

	def run
		fill_web_hole until time_to_stop?
	end

	def time_to_stop?
		true if @user.reload.allwebs_count >= 11 || (need_givers.blank? && need_receivers.blank?)
	end

	def fill_web_hole
		if giver_or_receiver == "giver" && need_receivers.present?
			receiver = need_givers.first
			web = Web.create(giver_id: @user.id, receiver_id: receiver.id)
		else
			giver = need_receivers.first
			web = Web.create(giver_id: giver.id, receiver_id: @user.id)
		end
		push web
	end

	def giver_or_receiver
		if @user.givers_count >= @user.receivers_count
			return "receiver"
		else
			return "giver"
		end
	end

	def push web
		giver = web.giver
		receiver = web.receiver
		json_package = SuspectSerializer.new giver, scope:receiver, root:'user'
		Pusher.trigger receiver.id,'new_suspect',json_package
		json_package = SuspectSerializer.new receiver, scope:giver, root:'user'
		Pusher.trigger giver.id,'new_suspect',json_package
	end
end