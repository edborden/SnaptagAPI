require 'test_helper'
require 'geo_calc'

class GeoCalcTest < ActiveSupport::TestCase

	def setup
		@z1 = Zone.create(lat:40.721923,lon:-74.007168,range:500)
		@z2 = Zone.create(lat:40.726216,lon:-73.976955,range:600)
	end		

	test "get_bearing_from" do
		assert_equal 259.39076824284336,GeoCalc::get_bearing_from(@z2.lat,@z2.lon,@z1.lat,@z1.lon)
	end

	test "get_new_point_with_bearing" do
		@z1 = Zone.create(lat:39,lon:-71,range:500)
		result = GeoCalc::get_destination_point(@z2.lat,@z2.lon,GeoCalc::get_bearing_from(@z2.lat,@z2.lon,@z1.lat,@z1.lon),GeoCalc::distance(@z1.lat,@z1.lon,@z2.lat,@z2.lon))
		# Accurate to -.5%/+.5%
		assert (result[:lat].to_f - (result[:lat].to_f * 0.005).abs <= @z1.lat.to_f) && (@z1.lat.to_f <= result[:lat].to_f + (result[:lat].to_f * 0.005).abs)
		assert (result[:lon].to_f - (result[:lon].to_f * 0.005).abs <= @z1.lon.to_f) && (@z1.lon.to_f <= result[:lon].to_f + (result[:lon].to_f * 0.005).abs)
	end

	test "compute_containg_zone" do
	end

end