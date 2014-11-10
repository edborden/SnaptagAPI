require 'test_helper'
require 'geo_calc'

class ZoneIntersectionCheckerTest < ActiveSupport::TestCase

	def setup
		@z1 = Zone.create(lat:40.721923,lng:-74.007168,range:500)
		@z2 = Zone.create(lat:40.726216,lng:-73.976955,range:600)
	end

	test "run" do
		testobject = Fabricate(:zone)
		2.times {ZoneIntersectionChecker.any_instance.expects(:zones_intersect?).returns(false)}
		assert_nil ZoneIntersectionChecker.new(testobject).run
	end

	test "zones_intersect?" do
		assert_not ZoneIntersectionChecker.new(@z1).zones_intersect?(@z2)
		distance = GeoCalc::distance(@z1.lat,@z1.lng,@z2.lat,@z2.lng)
		@z1.range = distance / 2 + 1
		@z1.save
		@z2.range = distance / 2 + 1
		@z2.save
		assert ZoneIntersectionChecker.new(@z1).zones_intersect?(@z2)
	end

end