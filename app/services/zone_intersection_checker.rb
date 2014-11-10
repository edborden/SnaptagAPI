class ZoneIntersectionChecker

	def initialize(test_zone)
		@test_zone = test_zone
	end

	def run
		response = nil
		Zone.all.each do |zone|
			next if zone == @test_zone
			if zones_intersect? zone
				response = zone
				break
			end
		end
		return response
	end

	# http://stackoverflow.com/questions/8367512/algorithm-to-detect-if-a-circles-intersect-with-any-other-circle-in-the-same-pla
	def zones_intersect?(zone)
		r1 = @test_zone.range 
		r2 = zone.range
		eq1 = r1-r2
		eq2 = GeoCalc::distance(@test_zone.lat,@test_zone.lng,zone.lat,zone.lng)
		eq3 = r1+r2

		eq1 <= eq2 && eq2 <= eq3
	end

end