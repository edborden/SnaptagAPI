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
		Fabricate.times(30, :user, zone_id:zone.id) do
			after_create { |attrs| Fabricate(:location, user_id: attrs[:id], lat: (rand*0.2 -0.1) + zone.lat, lon: (rand*0.2 -0.1) + zone.lon)}
		end
	end

end
