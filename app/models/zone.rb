require 'haversine'

class Zone < ActiveRecord::Base
	has_many :users

	# WHICH ZONE AM I IN?

	def self.determine_zone(user)
		response = nil
		user_location = [user.locations.last.lat,user.locations.last.lon]
		Zone.all.each do |zone|
			zone_center = [zone.lat,zone.lon]
			distance = Haversine.distance(zone_center,user_location).to_m
			if distance <= zone.range
				response = zone
				break
			end
		end
		return response
	end

	def self.create_or_grow(location)
	# IF I'M NOT IN A ZONE, THEN I CREATE A NEW ONE.
		created_zone = create_from_location(location)
	# DOES IT INTERSECT WITH ANY EXISTING ZONES? 
		intersecting_zone = intersects_with_existing?(created_zone)
	# DOES IT INTERSECT WITH ANY EXISTING ZONES? 
		if intersecting_zone.nil?
			return created_zone
		else
	# IF SO, THEN I GROW THE ZONE.
	# IF I GROW THE ZONE, DOES THAT NEW ZONE INTERSECT WITH OTHER ZONES? THEN IT GROWS MORE.
			start_zone = created_zone
			while intersecting_zone
				expanded_zone = join_zones(start_zone,intersecting_zone)
				intersecting_zone = intersects_with_existing?(expanded_zone)
				start_zone = expanded_zone if intersecting_zone
			end
			return expanded_zone
		end
	end

	def create_from_location(location)
		zone = create! do |zone|
			zone.lat = location.lat
			zone.lon = location.lon
		end
	end

	

	## WHEN I LEAVE THE GAME, IF MY "ZONE" INTERSECTS WITH THE MASTER ZONE, THEN THE MASTER ZONE SHRINKS
	# FIND THE USER FARTHEST FROM THE CENTER
	# CREATE A "PRETEND" ZONE AROUND THEM
	# FIND CENTER
	# ADJUST MASTER ZONE'S RADIUS, BUT NOT USING FORMULA


end