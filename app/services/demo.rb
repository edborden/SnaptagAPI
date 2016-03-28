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
			lat = near(zone.lat)
			lng = near(zone.lng)
			user = Fabricate(:user, zone_id:zone.id) do
				after_create do |attrs| 
					25.times do
						Fabricate :location, user_id: attrs[:id], lat: lat, lng: lng
					end
				end
			end
			activationqueue.users<<user
			json_package = UserSerializer.new user
			Pusher.trigger "activationqueue"+activationqueue.id.to_s,"Add user to activationqueue",json_package
		end
		ZoneRebuilder.new(zone).run		
	end

	def create_completed_hunts_in zone
		5.times do
			stalker = User.active.shuffle.first
			target = User.active.shuffle.first
			Hunt.create stalker_id: stalker.id,
				target_id: target.id,
				active: false,
				lat: near(zone.lat),
				lng: near(zone.lng),
				completed_at: Time.now,
				image_id: "hunts/ymoi2pofvylt4q0npdbt",
				detail: "#{stalker.name} snaptagged #{target.name}"
		end
	end

	def near geo
		rand (geo - 0.01)..(geo + 0.01)
	end

end
