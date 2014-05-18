require 'test_helper'
require 'haversine'

class ZoneHandlerTest < ActiveSupport::TestCase

	test "intersects_with_existing" do
		testobject = Fabricate(:zone)
		3.times {Fabricate(:zone)}
		3.times {ZoneHandler.any_instance.expects(:zones_intersect?).returns(false)}
		assert_nil ZoneHandler.new(testobject).intersects_with_existing?
	end

	test "zones_intersect?" do
		zone1 = Zone.create(lat:40.721923,lon:-74.007168,range:200)
		zone2 = Zone.create(lat:40.726216,lon:-73.976955,range:200)
		assert_not ZoneHandler.new(zone1,zone2).zones_intersect?
		distance = Haversine.distance(40.721923,-74.007168,40.726216,-73.976955).to_m
		zone1.range = distance / 2 + 1
		zone1.save
		zone2.range = distance / 2 + 1
		zone2.save
		assert ZoneHandler.new(zone1,zone2).zones_intersect?
	end

	test "get_bearing_from" do
		zone1 = Zone.create(lat:40.721923,lon:-74.007168,range:500)
		zone2 = Zone.create(lat:40.726216,lon:-73.976955,range:600)
		assert_equal 259.39076824284336,ZoneHandler.new(zone1,zone2).set_range_variables.get_bearing_from
	end

	test "get_new_point_with_bearing" do
		zone1 = Zone.create(lat:30,lon:-33.0,range:500)
		zone2 = Zone.create(lat:40.726216,lon:-73.976955,range:600)
		result = ZoneHandler.new.get_new_point_with_bearing(zone2,ZoneHandler.new(zone1,zone2).set_range_variables.get_bearing_from,Haversine.distance([zone1.lat,zone1.lon],[zone2.lat,zone2.lon]).to_m)
		# Accurate to -.5%/+.5%
		assert (result[:lat].to_f - (result[:lat].to_f * 0.005).abs <= zone1.lat.to_f) && (zone1.lat.to_f <= result[:lat].to_f + (result[:lat].to_f * 0.005).abs)
		assert (result[:lon].to_f - (result[:lon].to_f * 0.005).abs <= zone1.lon.to_f) && (zone1.lon.to_f <= result[:lon].to_f + (result[:lon].to_f * 0.005).abs)
	end

	#test "join_zones" do
	#	ZoneHandler.any_instance.expects(:set_range_variables)
	#	ZoneHandler.any_instance.expects(:get_bearing_from)
	#end

	test "join" do
		zone1 = Zone.create(lat:40.721923,lon:-74.007168,range:300)
		zone2 = Zone.create(lat:40.726216,lon:-73.976955,range:1800)
		assert_equal 12, ZoneHandler.new(zone1,zone2).join_zones
	end

end