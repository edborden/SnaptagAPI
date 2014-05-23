require 'test_helper'

class ZoneTest < ActiveSupport::TestCase

	test "determine_zone_for" do
		10.times {Fabricate(:zone)}
		nycuser = Fabricate(:user_in_nyc)
		nyczone = Fabricate(:zone_in_nyc, range:200000)
		assert_equal nyczone,Zone.determine_zone_for(nycuser.locations.first.lat,nycuser.locations.first.lon)
		user = Fabricate(:user_with_location)
		assert_nil Zone.determine_zone_for(user.locations.first.lat,user.locations.first.lon)
	end

	test "create_or_grow with no intersecting" do
		testobject = "testobject"
		testobject.expects(:locations).twice.returns(testobject)
		testobject.expects(:first).twice.returns(testobject)
		testobject.expects(:lat)
		testobject.expects(:lon)
		testobject.expects(:id)
		Zone.expects(:create).returns(testobject)
		ZoneIntersectionChecker.expects(:new).with(testobject).returns(testobject)
		testobject.expects(:run).returns(nil)
		assert_equal testobject,Zone.create_or_grow(testobject)
	end

	test "create_or_grow with intersecting" do
		testobject = "testobject"
		testobject2 = "testobject2"
		testobject3 = "testobject3"
		testobject.expects(:locations).twice.returns(testobject)
		testobject.expects(:first).twice.returns(testobject)
		testobject.expects(:lat)
		testobject.expects(:lon)
		testobject.expects(:id)
		Zone.expects(:create).returns(testobject3)
		ZoneIntersectionChecker.expects(:new).with(testobject3).returns(testobject)
		ZoneJoiner.expects(:new).with(testobject3,testobject,true).returns(testobject)
		testobject.expects(:run).returns(testobject).twice
		ZoneIntersectionChecker.expects(:new).with(testobject).returns(testobject2)
		testobject2.expects(:run).returns(nil)		
		assert_equal testobject,Zone.create_or_grow(testobject)
	end

end