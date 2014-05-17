require 'haversine'

class Zone < ActiveRecord::Base
	has_many :users

	# WHICH ZONE AM I IN?

	def self.determine_zone(user)
		response = nil
		user_location = [user.locations.last.latitude,user.locations.last.longitude]
		Zone.all.each do |zone|
			zone_center = [zone.latitude,zone.longitude]
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
		if intersecting_zone == nil
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
		end
	end

	def create_from_location(location)
		zone = create! do |zone|
			zone.latitude = location.latitude
			zone.longitude = location.longitude
		end
	end



	def intersects_with_existing?(test_zone)
		response = nil
		Zone.all.each do |zone|
			if zones_intersect?(test_zone,zone)
				response = zone
				break
			end
		end
		return response
	end

	# http://stackoverflow.com/questions/8367512/algorithm-to-detect-if-a-circles-intersect-with-any-other-circle-in-the-same-pla
	def zones_intersect?(zone1,zone2)
		x0 = zone1.latitude
		y0 = zone1.longitude
		r0 = zone1.range
		x1 = zone2.latitude
		y1 = zone2.longitude
		r1 = zone2.range
		eq1 = (r0-r1)**2
		eq2 = (x0-x1)**2+(y0-y1)^2
		eq3 = (r0+r1)**2

		if eq1 <= eq2 && eq2 <= eq3
			return true
		else 
			return false
		end
	end

	## THIS CAUSES A WRITE OPERATION TO EVERY USER IN THE SMALLER ZONE(S)
	# http://stackoverflow.com/questions/2084695/finding-the-smallest-circle-that-encompasses-other-circles
	def join_zones(zone1,zone2)
		set_range_variables(zone1,zone2)
		x0 = @smaller_zone.latitude
		y0 = @smaller_zone.longitude
		r0 = @smaller_zone.range
		x1 = @larger_zone.latitude
		y1 = @larger_zone.longitude
		r1 = @larger_zone.range
		distance = Haversine.distance(x0,y0,x1,y1)
		new_zone_range = (distance + r0 + r1) / 2
		theta = 1/2 + (r0 - r1) / (2 * distance)
		new_zone_latitude = (1-theta)*x0 + theta*x1
		new_zone_longitude = (1-theta)*y0 + theta*y1
		set_engulfing_variables(zone1,zone2)
		@engulfing_zone.latitude = new_zone_latitude
		@engulfing_zone.longitude = new_zone_longitude
		@engulfing_zone.range = new_zone_range
		@engulfing_zone.save
		@zone_to_be_engulfed.users.each do |user|
			user.zone = @engulfing_zone
			user.save
		end
		@zone_to_be_engulfed.destroy
		return @engulfing_zone
	end

	def set_range_variables(zone1,zone2)
		if zone1.range >= zone2.range
			@larger_zone = zone1
			@smaller_zone = zone2
		else
			larger_zone = zone2
			smaller_zone = zone1
		end
	end

	def set_engulfing_variables(zone1,zone2)
		if zone1.users.count >= zone2.users.count
			@engulfing_zone = zone1
			@zone_to_be_engulfed = zone2
		else
			@engulfing_zone = zone2
			@zone_to_be_engulfed = zone1
		end
	end		

	## WHEN I LEAVE THE GAME, IF MY "ZONE" INTERSECTS WITH THE MASTER ZONE, THEN THE MASTER ZONE SHRINKS
	# FIND THE USER FARTHEST FROM THE CENTER
	# CREATE A "PRETEND" ZONE AROUND THEM
	# FIND CENTER
	# ADJUST MASTER ZONE'S RADIUS, BUT NOT USING FORMULA


end