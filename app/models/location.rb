require 'haversine'

class Location < ActiveRecord::Base
	belongs_to :user
	belongs_to :zone

	def self.create_from_client(user,params)
		create! do |location|
			location.user_id = user.id
			location.latitude = params[:latitude]
			location.longitude = params[:longitude]
			location.accuracy = params[:accuracy]
			location.timestamp = params[:timestamp]
		end
	end

	def set_zone
		zone = determine_zone
		if zone
			self.zone = zone
			save
		else
			zone = Zone.create_from_location(self)
			self.zone = zone
			save
		end
	end

	def determine_zone
		zones = []
		Zone.all.each do |zone|
			zone_center = [zone.latitude,zone.longitude]
			self_center = [self.latitude,self.longitude]
			distance = Haversine.distance(zone_center,self_center).to_m
			if distance >= DEFAULT_MAX_DISTANCE + zone.range
				zones += [zone]
			end
		end
		if zones.count > 1
			zone = Zone.join_zone(zone)
			return zone
		elsif zones.count == 1
			return zones.first
		else
			return null
	end

	#def push_location_update_request
	#	Pusher.trigger(self.user.token, 'updatelocation', {message:"updatelocation"}) if self.locationrequests.count == 1
	#end

	#def clear_locationrequests
	#	locationrequests.destroy_all
	#end

end