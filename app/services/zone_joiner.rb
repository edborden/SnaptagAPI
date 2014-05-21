require 'geo_calc'

class ZoneJoiner

	def initialize(z1,z2,set_grow_id)
		@z1 = z1
		@z2 = z2
		@set_grow_id = set_grow_id
	end

	## THIS CAUSES A WRITE OPERATION TO EVERY USER IN THE SMALLER ZONE(S)
	def run
		set_range_variables
		new_zone = GeoCalc::compute_containing_zone(@larger_zone,@smaller_zone)
		set_engulfing_variables
		@engulfing_zone.lat = new_zone.lat
		@engulfing_zone.lon = new_zone.lon
		@engulfing_zone.range = new_zone.range
		if @set_grow_id
			@engulfing_zone.grow_id = @zone_to_be_engulfed.grow_id 
		else
			@engulfing_zone.grow_id = nil
		end
		@engulfing_zone.save
		@zone_to_be_engulfed.users.each do |user|
			user.zone = @engulfing_zone
		end
		@zone_to_be_engulfed.destroy
		return @engulfing_zone
	end

	def set_range_variables
		if @z1.range >= @z2.range
			@larger_zone = @z1
			@smaller_zone = @z2
		else
			@larger_zone = @z2
			@smaller_zone = @z1
		end
		return self
	end

	def set_engulfing_variables
		if @z1.users.count >= @z2.users.count
			@engulfing_zone = @z1
			@zone_to_be_engulfed = @z2
		else
			@engulfing_zone = @z2
			@zone_to_be_engulfed = @z1
		end
	end

end