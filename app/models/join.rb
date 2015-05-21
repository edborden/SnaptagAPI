class Join

	def initialize user,location_params

		user.locations.create location_params
		user.activate
		user.reload

		########
		########
		#Demo.new.create_activationqueue_around current_user
		########
		########

		activationqueue = Activationqueue.find_by_zone_id(user.zone_id) || Activationqueue.create(zone_id: user.zone_id)
		activationqueue.users<<user

		json_package = UserSerializer.new user
		Pusher.trigger "activationqueue"+activationqueue.id.to_s,"Add user to activationqueue",json_package

		user.notify "Added to activationqueue",nil,activationqueue

		HuntsHoleFiller.new.run

	end

end