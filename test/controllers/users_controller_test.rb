require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	test "api call with unmatching token" do
		skip
		get(:me, {token: "faketoken"})
		assert_equal 401,response.status
	end

	test "find, inactive map, no zone" do
		testuser = Fabricate(:user_in_nyc)
		Fabricate(:zone)
		get(:index, {token: testuser.token,lat: testuser.lat,lon: testuser.lon,inactive_map: true})
		assert_equal 200,@response.status
		assert_equal "none",@response.body
	end

	test "find, inactive map, active zone, mocked" do
		nyczone = Fabricate(:zone_in_nyc)
		Fabricate(:user_in_nyc, zone_id: nyczone.id)
		testuser = Fabricate(:user_in_nyc)
		Zone.expects(:determine_nearest_zone_for).with(testuser.lat,testuser.lon).returns(nyczone)
		nyczone.expects(:within_50km_of).with(testuser.lat,testuser.lon).returns(true)
		nyczone.expects(:active?).with(nil).returns(true).twice
		get(:index, {token: testuser.token,lat: testuser.lat,lon: testuser.lon,inactive_map: true})
		assert_equal 200,@response.status
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal true,json_response["zones"][0]["active"]	
	end	

	test "find, inactive map, active zone" do
		nyczone = Fabricate(:zone_in_nyc)
		Fabricate(:user_in_nyc, zone_id: nyczone.id)
		testuser = Fabricate(:user_in_nyc)
		get(:index, {token: testuser.token,lat: testuser.lat,lon: testuser.lon,inactive_map: true})
		assert_equal 200,@response.status
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal nyczone.active?,json_response["zones"][0]["active"]	
	end

	test "find,inactive map, queue zones before active zone,mocked" do
		nyczone = Fabricate(:zone_in_nyc)
		Fabricate(:user_in_nyc, zone_id: nyczone.id)
		boontonzone = Fabricate(:zone_in_boonton)
		Fabricate(:user_in_boonton, zone_id: boontonzone.id)
		testuser = Fabricate(:user_in_nyc)
		Zone.expects(:determine_nearest_zone_for).with(testuser.lat,testuser.lon).returns(nyczone)
		nyczone.expects(:within_50km_of).with(testuser.lat,testuser.lon).returns(true).twice
		nyczone.expects(:active?).with(nil).returns(false).times(3)
		Zone.expects(:determine_nearest_zone_for).with(testuser.lat,testuser.lon,[nyczone]).returns(boontonzone)
		boontonzone.expects(:active?).with(nil).returns(true).twice
		get(:index, {token: testuser.token,lat: testuser.lat,lon: testuser.lon,inactive_map: true})
		assert_equal 200,@response.status
		assert_equal 2,json_response["zones"].count
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal true,json_response["zones"][1]["active"]
	end	

	test "find,inactive map, queue zones before active zone,integration" do
		nyczone = Fabricate(:zone_in_nyc)
		Fabricate(:user_in_nyc, zone_id: nyczone.id,activationqueue_id: 1)
		boontonzone = Fabricate(:zone_in_boonton)
		Fabricate(:user_in_boonton, zone_id: boontonzone.id)
		testuser = Fabricate(:user_in_nyc)
		get(:index, {token: testuser.token,lat: testuser.lat,lon: testuser.lon,inactive_map: true})
		assert_equal 200,@response.status
		assert_equal 2,json_response["zones"].count
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal true,json_response["zones"][1]["active"]
	end

	test "find,inactive map, only queue zones" do
		nyczone = Fabricate(:zone_in_nyc)
		Fabricate(:user_in_nyc, zone_id: nyczone.id,activationqueue_id: 1)
		boontonzone = Fabricate(:zone_in_boonton)
		Fabricate(:user_in_boonton, zone_id: boontonzone.id,activationqueue_id: 10)
		Fabricate(:zone)
		testuser = Fabricate(:user_in_nyc)
		get(:index, {token: testuser.token,lat: testuser.lat,lon: testuser.lon,inactive_map: true})
		assert_equal 200,@response.status
		assert_equal 2,json_response["zones"].count
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal false,json_response["zones"][1]["active"]
	end

end