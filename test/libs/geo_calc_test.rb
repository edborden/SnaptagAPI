require 'test_helper'
require 'geo_calc'

class GeoCalcTest < ActiveSupport::TestCase

	def setup
		@z1 = Zone.create(lat:40.721923,lng:-74.007168,range:500)
		@z2 = Zone.create(lat:40.726216,lng:-73.976955,range:600)
	end		

	test "get_bearing_from" do
		assert_equal 259.39076824284336,GeoCalc::get_bearing_from(@z2.lat,@z2.lng,@z1.lat,@z1.lng)
	end

	test "get_new_point_with_bearing" do
		@z1 = Zone.create(lat:39,lng:-71,range:500)
		result = GeoCalc::get_destination_point(@z2.lat,@z2.lng,GeoCalc::get_bearing_from(@z2.lat,@z2.lng,@z1.lat,@z1.lng),GeoCalc::distance(@z1.lat,@z1.lng,@z2.lat,@z2.lng))
		# Accurate to -.5%/+.5%
		assert (result[:lat].to_f - (result[:lat].to_f * 0.005).abs <= @z1.lat.to_f) && (@z1.lat.to_f <= result[:lat].to_f + (result[:lat].to_f * 0.005).abs)
		assert (result[:lng].to_f - (result[:lng].to_f * 0.005).abs <= @z1.lng.to_f) && (@z1.lng.to_f <= result[:lng].to_f + (result[:lng].to_f * 0.005).abs)
	end

	test "compute_containing_zone" do
		response = GeoCalc.compute_containing_zone(@z2,@z1)
		assert_instance_of Zone, response
		assert response.lat.present?
	end

end