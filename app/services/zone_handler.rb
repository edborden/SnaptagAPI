class ZoneHandler

	def initialize(zone1=nil,zone2=nil)
		@zone1 = zone1
		@zone2 = zone2
	end

	def intersects_with_existing?
		response = nil
		Zone.all.each do |zone|
			@zone2 = zone
			next if @zone2 == @zone1
			if zones_intersect?
				response = zone
				break
			end
		end
		return response
	end

	# http://stackoverflow.com/questions/8367512/algorithm-to-detect-if-a-circles-intersect-with-any-other-circle-in-the-same-pla
	def zones_intersect?
		r1 = @zone1.range 
		r2 = @zone2.range
		eq1 = r1-r2
		eq2 = Haversine.distance(@zone1.lat,@zone1.lon,@zone2.lat,@zone2.lon).to_m
		eq3 = r1+r2

		if eq1 <= eq2 && eq2 <= eq3
			return true
		else 
			return false
		end
	end

	## THIS CAUSES A WRITE OPERATION TO EVERY USER IN THE SMALLER ZONE(S)
	def join_zones
		set_range_variables
		size_ratio = 1 - (@smaller_zone.range.to_f / @larger_zone.range.to_f)
		brng = get_bearing_from
		distance = (Haversine.distance(@zone1.lat,@zone1.lon,@zone2.lat,@zone2.lon).to_m / (2+size_ratio))
		new_center = get_new_point_with_bearing(@larger_zone,brng,distance)
		new_range = distance + @larger_zone.range
		set_engulfing_variables
		@engulfing_zone.lat = new_center[:lat]
		@engulfing_zone.lon = new_center[:lon]
		@engulfing_zone.range = new_range
		@engulfing_zone.save
		@zone_to_be_engulfed.users.each do |user|
			user.zone = @engulfing_zone
			user.save
		end
		@zone_to_be_engulfed.destroy
		return @engulfing_zone
	end

	def set_range_variables
		if @zone1.range >= @zone2.range
			@larger_zone = @zone1
			@smaller_zone = @zone2
		else
			@larger_zone = @zone2
			@smaller_zone = @zone1
		end
		return self
	end

	def get_bearing_from
		φ1 = @larger_zone.lat * DEGREE_TO_RADIAN
		φ2 = @smaller_zone.lat * DEGREE_TO_RADIAN
		Δλ = (@smaller_zone.lon-@larger_zone.lon) * DEGREE_TO_RADIAN

		y = Math.sin(Δλ) * Math.cos(φ2)
		x = Math.cos(φ1)*Math.sin(φ2) - Math.sin(φ1)*Math.cos(φ2)*Math.cos(Δλ)
		θ = Math.atan2(y, x)

		response = (θ * RADIAN_TO_DEGREES + 360) % 360
		return response
	end

	## -.5%/+.5% error
	def get_new_point_with_bearing(zone,brng,distance)
	    θ = brng * DEGREE_TO_RADIAN
	    δ = distance * 0.001 / R 

	    φ1 = zone.lat * DEGREE_TO_RADIAN
	    λ1 = zone.lon * DEGREE_TO_RADIAN

	    φ2 = Math.asin( Math.sin(φ1)*Math.cos(δ) + Math.cos(φ1)*Math.sin(δ)*Math.cos(θ) )
	    λ2 = λ1 + Math.atan2(Math.sin(θ)*Math.sin(δ)*Math.cos(φ1), Math.cos(δ)-Math.sin(φ1)*Math.sin(φ2))
	    λ2 = (λ2+3*PI) % (2*PI) - PI

	    return {lat:φ2*RADIAN_TO_DEGREES,lon:λ2*RADIAN_TO_DEGREES}
	end

	def set_engulfing_variables
		if @zone1.users.count >= @zone2.users.count
			@engulfing_zone = @zone1
			@zone_to_be_engulfed = @zone2
		else
			@engulfing_zone = @zone2
			@zone_to_be_engulfed = @zone1
		end
	end		

end