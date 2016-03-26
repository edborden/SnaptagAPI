class Demo

	def zones_controller lat,lng
		zone = Zone.determine_zone_for lat,lng
		unless zone
			zone = Zone.create lat:lat,lng:lng
			create_users_in zone
		end
	end

	def web
#		ed = User.find_by(name: "Ed")
		activationqueue = Activationqueue.create
		3.times { Fabricate(:user_with_location,activationqueue_id: activationqueue.id) }
		25.times { Fabricate(:active_test_user) }
	end

	def create_users_in zone,num=30
		Fabricate.times(num, :active_demo_user, zone_id:zone.id) do
			after_create { |attrs| Fabricate(:location, user_id: attrs[:id], lat: (rand*0.075 -0.0375) + zone.lat, lng: (rand*rand*0.075 -0.0375) + zone.lng)}
		end
		ZoneRebuilder.new(zone).run
	end

	def create_activationqueue_around user
		zone = user.zone
		activationqueue = Activationqueue.create(zone_id: zone.id)
		add_users_to activationqueue,3
	end

	def add_users_to activationqueue,num=1
		zone = activationqueue.zone
		num.times do
			user = Fabricate(:user, zone_id:zone.id) do
				after_create do |attrs| 
					25.times do
						Fabricate :location, user_id: attrs[:id], lat: near(zone.lat), lng: near(zone.lng)
					end
				end
			end
			activationqueue.users<< user
			json_package = UserSerializer.new user
			Pusher.trigger "activationqueue"+activationqueue.id.to_s,"Add user to activationqueue",json_package
		end
		ZoneRebuilder.new(zone).run		
	end

	def create_completed_hunts_in zone
		5.times do 
			Hunt.create stalker_id: User.active.shuffle.first.id,
				target_id: User.active.shuffle.first.id,
				active: false,
				lat: near(zone.lat),
				lng: near(zone.lng),
				completed_at: Time.now
		end
	end

	def near geo
		rand (geo - 0.001)..(geo + 0.001)
	end

end
