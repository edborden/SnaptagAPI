module GeoCalc

	DEGREE_TO_RADIAN = 0.01745327
	RADIAN_TO_DEGREES = 57.2957795
	R = 6371 # radius of earth in km
	PI = 3.14159265359

	# Equirectangular approximation good enough http://www.movable-type.co.uk/scripts/latlong.html
	def GeoCalc.distance(lat1,lng1,lat2,lng2)
		φ1 = lat1 * DEGREE_TO_RADIAN
		λ1 = lng1 * DEGREE_TO_RADIAN
		φ2 = lat2 * DEGREE_TO_RADIAN
		λ2 = lng2 * DEGREE_TO_RADIAN
		x = (λ2-λ1) * Math.cos((φ1+φ2)/2)
		y = (φ2-φ1)
		d = Math.sqrt(x*x + y*y) * R * 1000
	end

	def GeoCalc.get_bearing_from(lat1,lng1,lat2,lng2)
		φ1 = lat1 * DEGREE_TO_RADIAN
		φ2 = lat2 * DEGREE_TO_RADIAN
		Δλ = (lng2-lng1) * DEGREE_TO_RADIAN
		cosφ2 = Math.cos(φ2)

		y = Math.sin(Δλ) * cosφ2
		x = Math.cos(φ1)*Math.sin(φ2) - Math.sin(φ1)*cosφ2*Math.cos(Δλ)
		θ = Math.atan2(y, x)

		response = (θ * RADIAN_TO_DEGREES + 360) % 360
	end

	def GeoCalc.get_destination_point(lat,lng,brng,distance)
		θ = brng * DEGREE_TO_RADIAN
		δ = distance * 0.001 / R 

		φ1 = lat * DEGREE_TO_RADIAN
		λ1 = lng * DEGREE_TO_RADIAN
		sinφ1 = Math.sin(φ1)
		cosδ = Math.cos(δ)

		φ2 = Math.asin( sinφ1*cosδ + Math.cos(φ1)*Math.sin(δ)*Math.cos(θ) )
		λ2 = λ1 + Math.atan2(Math.sin(θ)*Math.sin(δ)*Math.cos(φ1), cosδ-sinφ1*Math.sin(φ2))
		λ2 = (λ2+3*PI) % (2*PI) - PI

		return {lat:φ2*RADIAN_TO_DEGREES,lng:λ2*RADIAN_TO_DEGREES}
	end

	def GeoCalc.compute_containing_zone(larger_zone,smaller_zone)
		size_ratio = 1 - (smaller_zone.range.to_f / larger_zone.range.to_f)
		brng = GeoCalc.get_bearing_from(larger_zone.lat,larger_zone.lng,smaller_zone.lat,smaller_zone.lng)
		distance = (GeoCalc.distance(larger_zone.lat,larger_zone.lng,smaller_zone.lat,smaller_zone.lng) / (2+size_ratio))
		new_center = GeoCalc.get_destination_point(larger_zone.lat,larger_zone.lng,brng,distance)
		new_range = distance + larger_zone.range
		return Zone.new(lat: new_center[:lat],lng: new_center[:lng],range: new_range)
	end

end