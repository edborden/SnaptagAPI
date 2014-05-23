require 'test_helper'

class ZoneTest < ActiveSupport::TestCase

	def setup
		@nyczone = Fabricate(:zone_in_nyc)
		@nycuser = Fabricate(:user_in_nyc, zone_id: @nyczone.id)
	end

	test "determine_zone_for" do
		10.times {Fabricate(:zone)}
		assert_equal @nyczone,Zone.determine_zone_for(@nycuser.locations.first.lat,@nycuser.locations.first.lon)
		user = Fabricate(:user_with_location)
		assert_nil Zone.determine_zone_for(user.locations.first.lat,user.locations.first.lon)
	end

	test "determine_nearest_zone_for" do
	end

	test "create_or_grow with no intersecting" do
		testobject = "testobject"
		Zone.expects(:create).returns(testobject)
		ZoneIntersectionChecker.expects(:new).with(testobject).returns(stub(:run => nil))
		assert_equal testobject,Zone.create_or_grow(@nycuser)
	end

	test "create_or_grow with intersecting" do
		testobject = "testobject"
		testobject2 = "testobject2"
		testobject3 = "testobject3"
		Zone.expects(:create).returns(testobject)
		ZoneIntersectionChecker.expects(:new).with(testobject).returns(stub(:run => testobject2))
		ZoneJoiner.expects(:new).with(testobject,testobject2,true).returns(stub(:run => testobject3))
		ZoneIntersectionChecker.expects(:new).with(testobject3).returns(stub(:run => nil))
		assert_equal testobject3,Zone.create_or_grow(@nycuser)
	end

	test "contains?" do
		GeoCalc.expects(:distance).with(10,10,@nyczone.lat,@nyczone.lon).returns(100)
		@nyczone.contains?(10,10)
	end

	test "remove_user, empty, deletes" do
		@nyczone.expects(:destroy)
		@nyczone.remove_user(@nycuser)
	end

	test "remove_user, no grow_id" do
		Fabricate(:user_in_nyc, zone_id: @nyczone.id)
		GeoCalc.expects(:distance).with(@nyczone.lat,@nyczone.lon,@nycuser.locations.first.lat,@nycuser.locations.first.lon).returns(7501)
		ZoneRebuilder.expects(:new).with(@nyczone).returns(stub(:run))
		@nyczone.remove_user(@nycuser)
	end

	test "remove_user, with matching grow_id" do
		@nyczone.grow_id = @nycuser.id
		Fabricate(:user_in_nyc, zone_id: @nyczone.id)
		ZoneRebuilder.expects(:new).with(@nyczone).returns(stub(:run))
		@nyczone.remove_user(@nycuser)
	end

end