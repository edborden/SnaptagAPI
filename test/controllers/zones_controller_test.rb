require 'test_helper'

class ZonesControllerTest < ActionController::TestCase

	test "api call with unmatching token" do
		skip
		get(:me, {token: "faketoken"})
		assert_equal 401,response.status
	end

	test "index, no zone" do
		testuser = Fabricate :user_in_nyc
		Fabricate :zone
		get :index, {lat: testuser.lat,lng: testuser.lng}
		assert_equal 200,@response.status
		assert_equal "{\"zones\":[]}",@response.body
	end

	test "index, active zone" do
		nyczone = Fabricate :zone_in_nyc
		Fabricate :user_in_nyc, zone_id: nyczone.id
		testuser = Fabricate :user_in_nyc
		get :index, {lat: testuser.lat,lng: testuser.lng}
		assert_equal 200,@response.status
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal nyczone.active,json_response["zones"][0]["active"]	
	end

	test "index, queue zones before active zone,integration" do
		nyczone = Fabricate :zone_in_nyc
		Fabricate :user_in_nyc, zone_id: nyczone.id,activationqueue_id: 1
		boontonzone = Fabricate :zone_in_boonton
		Fabricate :user_in_boonton, zone_id: boontonzone.id
		testuser = Fabricate :user_in_nyc
		get :index, {lat: testuser.lat,lng: testuser.lng}
		assert_equal 200,@response.status
		assert_equal 2,json_response["zones"].count
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal true,json_response["zones"][1]["active"]
	end

	test "index, only queue zones in range" do
		nyczone = Fabricate :zone_in_nyc
		Fabricate :user_in_nyc, zone_id: nyczone.id,activationqueue_id: 1
		boontonzone = Fabricate :zone_in_boonton
		Fabricate :user_in_boonton, zone_id: boontonzone.id,activationqueue_id: 10
		Fabricate :zone
		testuser = Fabricate :user_in_nyc
		get :index, {lat: testuser.lat,lng: testuser.lng}
		assert_equal 200,@response.status
		assert_equal 2,json_response["zones"].count
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal false,json_response["zones"][1]["active"]
	end

	test "index, only queue zones in the whole game" do
		nyczone = Fabricate :zone_in_nyc
		Fabricate :user_in_nyc, zone_id: nyczone.id,activationqueue_id: 1
		boontonzone = Fabricate :zone_in_boonton
		Fabricate :user_in_boonton, zone_id: boontonzone.id,activationqueue_id: 10
		testuser = Fabricate :user_in_nyc
		get :index, {lat: testuser.lat,lng: testuser.lng}
		assert_equal 200,@response.status
		assert_equal 2,json_response["zones"].count
		assert_equal nyczone.id,json_response["zones"][0]["id"]
		assert_equal false,json_response["zones"][1]["active"]
	end

	#test "index from active user does not wipe zone_id and does not return self"
	#	nyczone = Fabricate :zone_in_nyc
	#	nycuser = Fabricate :user_in_nyc, zone_id: nyczone.id		
	#	get :index, {lat: testuser.lat,lng: testuser.lng}
	#end

end