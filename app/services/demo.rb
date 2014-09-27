class Demo

	def users_around(lat,lon)
		zone = Zone.determine_zone_for(lat,lon)
		unless zone
			zone = Zone.create(lat:lat,lon:lon)
			create_active_users_in zone
			ZoneRebuilder.new(zone).run
		end
	end

	def web
#		ed = User.find_by(name: "Ed")
		queue = Activationqueue.create
		11.times { Fabricate(:user_with_location,activationqueue_id: queue.id) }
		25.times { Fabricate(:active_test_user) }
	end

	def create_active_users_in zone
		Fabricate.times(30, :active_demo_user, zone_id:zone.id) do
			after_create { |attrs| Fabricate(:location, user_id: attrs[:id], lat: (rand*0.075 -0.0375) + zone.lat, lon: (rand*rand*0.075 -0.0375) + zone.lon)}
		end
	end

	def create_activationqueue_around user
		zone = user.zone
		queue = Activationqueue.create(zone_id: zone.id)
		Fabricate.times(11, :user, zone_id:zone.id, activationqueue_id:queue.id) do
			after_create { |attrs| 25.times { Fabricate(:location, user_id: attrs[:id], lat: (rand*rand*0.075 -0.0375) + zone.lat, lon: (rand*rand*0.075 -0.0375) + zone.lon)}}
		end
	end

end
