require 'test_helper'

class ZoneTest < ActiveSupport::TestCase

	test "determine_zone_for" do
		10.times {Fabricate(:zone)}
		nycuser = Fabricate(:user_in_nyc)
		nyczone = Fabricate(:zone_in_nyc, range:100000)
		assert_equal nyczone,Zone.determine_zone_for(nycuser)
		user = Fabricate(:user_with_location)
		assert_nil Zone.determine_zone_for(user)
	end

	test "create_or_grow with no intersecting" do
		testobject = "test object"
		Zone.expects(:create).returns(testobject)
		Zone.expects(:intersects_with_existing?).with(testobject).returns(nil)
		assert_equal testobject,Zone.create_or_grow(testobject)
	end

	test "create_or_grow with intersecting" do
		testobject = "test object"
		testobject2 = "test object 2"
		testobject3 = "test object 3"
		Zone.expects(:create).returns(testobject2)
		Zone.expects(:intersects_with_existing?).with(testobject2).returns(testobject)
		Zone.expects(:join_zones).with(testobject2,testobject).returns(testobject3)
		Zone.expects(:intersects_with_existing?).with(testobject3).returns(nil)
		assert_equal testobject3,Zone.create_or_grow(testobject)
	end

end