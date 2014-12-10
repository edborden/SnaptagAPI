class Demo

	def users_around(lat,lng)
		zone = Zone.determine_zone_for(lat,lng)
		unless zone
			zone = Zone.create(lat:lat,lng:lng)
			create_active_users_in zone
			ZoneRebuilder.new(zone).run
		end
	end

	def web
#		ed = User.find_by(name: "Ed")
		activationqueue = Activationqueue.create
		11.times { Fabricate(:user_with_location,activationqueue_id: activationqueue.id) }
		25.times { Fabricate(:active_test_user) }
	end

	def create_active_users_in zone
		Fabricate.times(30, :active_demo_user, zone_id:zone.id) do
			after_create { |attrs| Fabricate(:location, user_id: attrs[:id], lat: (rand*0.075 -0.0375) + zone.lat, lng: (rand*rand*0.075 -0.0375) + zone.lng)}
		end
	end

	def create_queue_around user
		zone = user.zone
		activationqueue = Activationqueue.create(zone_id: zone.id)
		Fabricate.times(11, :user, zone_id:zone.id, activationqueue_id:activationqueue.id) do
			after_create { |attrs| 25.times { Fabricate(:location, user_id: attrs[:id], lat: (rand*rand*0.075 -0.0375) + zone.lat, lng: (rand*rand*0.075 -0.0375) + zone.lng)}}
		end
	end

end
