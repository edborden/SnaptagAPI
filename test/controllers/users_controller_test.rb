require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	test "api call with unmatching token" do
		get(:me, {token: "faketoken"})
		assert_equal 401,response.status
	end

	test "login, new user" do
		fb_hash
		Facebook.expects(:new).with(@@fbhash["access_token"]).returns(stub(exchange_token: "newtoken",get_profile: @@fbhash))
		User.expects(:find_by).with(facebookid: @@fbhash["id"]).returns(nil)
		User.expects(:create_from_facebook).with("newtoken",@@fbhash).returns(stub(status: "active"))
		get(:login, {token: @@fbhash["access_token"]})
		assert_equal 200,@response.status
		assert_equal "active",json_response["status"]
		assert_equal "newtoken",json_response["token"]
	end

	test "login, new user, bad token" do
		# this won't work because of erroring out from facebook exchange token call
	end

	test "me" do
		user = Fabricate(:user)
		get(:me, {token: user.token})
		assert_equal 200,response.status
		assert_equal user.name, json_response['user']['name']
	end

	test "login existing user" do
		user = fb_user
		Facebook.expects(:new).with(@@fbhash["access_token"]).returns(stub(exchange_token: "newtoken",get_profile: @@fbhash))
		User.expects(:find_by).with(facebookid: user.facebookid).returns(user)
		user.expects(:set_token).with("newtoken")
		get(:login, {token: @@fbhash["access_token"]})
		assert_equal 200,@response.status
		assert_equal "inactive",json_response["status"]
		assert_equal "newtoken",json_response["token"]
	end

	test "user status" do
		user = Fabricate(:user)
		User.any_instance.expects(:status).returns("anything")
		get(:user_status, {token: user.token})
		assert_equal "anything",@response.body
	end

	test "find, inactive map, no zone" do
		testuser = Fabricate(:user_in_nyc)
		Fabricate(:zone)
		get(:find, {token: testuser.token,lat: testuser.locations.last.lat,lon: testuser.locations.last.lon,inactive_map: true})
		assert_equal "none",@response.body
	end

	test "find, inactive map, active zone, mocked" do
		nyczone = Fabricate(:zone_in_nyc)
		Fabricate(:user, zone_id: nyczone.id)
		testuser = Fabricate(:user_in_nyc)
		Zone.expects(:determine_nearest_zone_for).with(testuser.locations.last.lat,testuser.locations.last.lon).returns(nyczone)
		nyczone.expects(:within_50km_of).with(testuser.locations.last.lat,testuser.locations.last.lon).returns(true)
		nyczone.expects(:active?).with(nil).returns(true).twice
		get(:find, {token: testuser.token,lat: testuser.locations.last.lat,lon: testuser.locations.last.lon,inactive_map: true})
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal true,json_response["zones"][0]["active"]	
	end	

	test "find, inactive map, active zone" do
		nyczone = Fabricate(:zone_in_nyc)
		Fabricate(:user, zone_id: nyczone.id)
		testuser = Fabricate(:user_in_nyc)
		get(:find, {token: testuser.token,lat: testuser.locations.last.lat,lon: testuser.locations.last.lon,inactive_map: true})
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal nyczone.active?,json_response["zones"][0]["active"]	
	end

	test "find,inactive map, queue zones before active zone,mocked" do
		nyczone = Fabricate(:zone_in_nyc)
		Fabricate(:user, zone_id: nyczone.id)
		boontonzone = Fabricate(:zone_in_boonton)
		Fabricate(:user, zone_id: boontonzone.id)
		testuser = Fabricate(:user_in_nyc)
		Zone.expects(:determine_nearest_zone_for).with(testuser.locations.last.lat,testuser.locations.last.lon).returns(nyczone)
		nyczone.expects(:within_50km_of).with(testuser.locations.last.lat,testuser.locations.last.lon).returns(true).twice
		nyczone.expects(:active?).with(nil).returns(false).times(3)
		Zone.expects(:determine_nearest_zone_for).with(testuser.locations.last.lat,testuser.locations.last.lon,[nyczone]).returns(boontonzone)
		boontonzone.expects(:active?).with(nil).returns(true).twice
		get(:find, {token: testuser.token,lat: testuser.locations.last.lat,lon: testuser.locations.last.lon,inactive_map: true})
		assert_equal 2,json_response["zones"].count
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal true,json_response["zones"][1]["active"]
	end	

	test "find,inactive map, queue zones before active zone,integration" do
		nyczone = Fabricate(:zone_in_nyc)
		Fabricate(:user, zone_id: nyczone.id,activationqueue_id: 1)
		boontonzone = Fabricate(:zone_in_boonton)
		Fabricate(:user, zone_id: boontonzone.id)
		testuser = Fabricate(:user_in_nyc)
		get(:find, {token: testuser.token,lat: testuser.locations.last.lat,lon: testuser.locations.last.lon,inactive_map: true})
		assert_equal 2,json_response["zones"].count
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal true,json_response["zones"][1]["active"]
	end

	test "find,inactive map, only queue zones" do
		nyczone = Fabricate(:zone_in_nyc)
		Fabricate(:user, zone_id: nyczone.id,activationqueue_id: 1)
		boontonzone = Fabricate(:zone_in_boonton)
		Fabricate(:user, zone_id: boontonzone.id,activationqueue_id: 10)
		Fabricate(:zone)
		testuser = Fabricate(:user_in_nyc)
		get(:find, {token: testuser.token,lat: testuser.locations.last.lat,lon: testuser.locations.last.lon,inactive_map: true})
		assert_equal 2,json_response["zones"].count
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal false,json_response["zones"][1]["active"]
	end

end