require 'geo_calc'

class Zone < ActiveRecord::Base
	has_many :users

	# WHICH ZONE AM I IN?

	def self.determine_zone_for(lat,lon)
		response = nil
		Zone.all.each do |zone|
			if zone.contains?(lat,lon)
				response = zone
				break
			end
		end
		return response
	end

	def self.determine_nearest_zone_for(lat,lon,exclude_zones = nil)
		nearest_zone = nil
		nearest_zone_distance = nil
		if exclude_zones
			zones = Zone.all - exclude_zones 
		else
			zones = Zone.all
		end
		zones.each do |zone|
			distance = GeoCalc::distance(zone.lat,zone.lon,lat,lon)
			if nearest_zone == nil || distance < nearest_zone_distance
				nearest_zone = zone
				nearest_zone_distance = distance
			end
		end
		return nearest_zone
	end

	def self.create_or_grow(user)
	# IF I'M NOT IN A ZONE, THEN I CREATE A NEW ONE.
		created_zone = Zone.create(lat: user.flat,lon: user.flon,grow_id:user.id)
	# DOES IT INTERSECT WITH ANY EXISTING ZONES? 
		intersecting_zone = ZoneIntersectionChecker.new(created_zone).run
		if intersecting_zone.nil?
			return created_zone
		else
	# IF SO, THEN I GROW THE ZONE. LOG MY GROW_ID
	# IF I GROW THE ZONE, DOES THAT NEW ZONE INTERSECT WITH OTHER ZONES? THEN IT GROWS MORE. WIPE OUT THE GROW_ID.
			start_zone = created_zone
			set_grow_id = true
			while intersecting_zone
				expanded_zone = ZoneJoiner.new(start_zone,intersecting_zone,set_grow_id).run
				intersecting_zone = ZoneIntersectionChecker.new(expanded_zone).run
				start_zone = expanded_zone
				set_grow_id = false
			end
			return expanded_zone
		end
	end

	def contains?(lat,lon)
		distance = GeoCalc::distance(lat,lon,self.lat,self.lon)
		distance <= self.range
	end

	def remove_user(user)
	## WHEN I LEAVE THE GAME, IF I'M THE USER THE GREW THE ZONE (FARTHEST FROM CENTER, IDENTIFIED BY GROW_ID), REBUILD THE ZONE.
	# WHEN I LEAVE THE GAME AND THE ZONE HAS NO GROW_ID, IT NEEDS TO BE REBUILT IF MY DISTANCE FROM THE ZONE CENTER IS MORE THAN 50% OF THE ZONE RANGE
	# IF THE ZONE IS EMPTY, DELETE IT
		self.users.delete(user)
		if self.users.exists?
			if self.grow_id == user.id
				ZoneRebuilder.new(self).run
			elsif self.grow_id == nil
				ZoneRebuilder.new(self).run if GeoCalc::distance(self.lat,self.lon,user.flat,user.flon) > (self.range / 2)
			end
		else
			self.destroy
		end
	end

	# zone is active if it contains users that are not in a queue
	def active
		users.where(activationqueue_id: nil).present?
	end

	def within_50km_of lat,lon
		GeoCalc::distance(self.lat,self.lon,lat,lon) < 50000
	end

end