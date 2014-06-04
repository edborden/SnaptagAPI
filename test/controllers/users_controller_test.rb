require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	test "api call with unmatching token" do
		get(:me, {"token" => "faketoken"})
		assert_equal 401,response.status
	end

	test "login, new user" do
		fb_hash
		Facebook.expects(:new).with(@@fbhash["access_token"]).returns(stub(exchange_token: "newtoken",get_profile: @@fbhash))
		User.expects(:find_by).with(facebookid: @@fbhash["id"]).returns(nil)
		User.expects(:create_from_facebook).with("newtoken",@@fbhash).returns(stub(status: "active"))
		get(:login, {"token" => @@fbhash["access_token"]})
		assert_equal 200,@response.status
		assert_equal "active",json_response["status"]
		assert_equal "newtoken",json_response["token"]
	end

	test "login, new user, bad token" do
		# this won't work because of erroring out from facebook exchange token call
	end

	test "me" do
		user = Fabricate(:user)
		get(:me, {"token" => user.token})
		assert_equal 200,response.status
		assert_equal user.name, json_response['user']['name']
	end

	test "login existing user" do
		user = fb_user
		Facebook.expects(:new).with(@@fbhash["access_token"]).returns(stub(exchange_token: "newtoken",get_profile: @@fbhash))
		User.expects(:find_by).with(facebookid: user.facebookid).returns(user)
		user.expects(:set_token).with("newtoken")
		get(:login, {"token" => @@fbhash["access_token"]})
		assert_equal 200,@response.status
		assert_equal "inactive",json_response["status"]
		assert_equal "newtoken",json_response["token"]
	end

	test "user status" do
		user = Fabricate(:user)
		User.any_instance.expects(:status).returns("anything")
		get(:user_status, {"token" => user.token})
		assert_equal "anything",@response.body
	end

	test "find, inactive map, no zone" do
		user = Fabricate(:user)
		Fabricate(:zone)
		get(:find, {"token" => user.token,inactive_map: true})
		assert_equal "none",@response.body
	end

	test "find, inactive map, active zone" do
	end

	test "find,inactive map, queue zones before active zone" do
	end

end