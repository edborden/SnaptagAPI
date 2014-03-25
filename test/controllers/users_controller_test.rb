require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	test "me without token" do
		user = Fabricate(:user)
		get(:me)
		assert_equal 401,response.status
	end

	test "me with invalid token" do
		user = Fabricate(:user)
		get(:me, {"token" => "312456asdg"})
		assert_equal 401,response.status
	end

	test "me with valid token" do
		user = Fabricate(:user)
		get(:me, {"token" => user.token})
		assert_equal 200,response.status
		assert_equal user.firstname, json_response['user']['firstname']
	end

	test "new user" do
		fb_hash
		User.expects(:find_by).with(facebookid: @@fbprofile["id"]).returns(nil)
		Facebook.expects(:new).returns(stub(verify_token?: true))
		User.expects(:create_from_facebook).with(@@fbhash["access_token"])
		get(:login, {"facebookid" => @@fbprofile["id"], "token" => @@fbhash["access_token"]})
		assert_equal 200,@response.status
	end

	test "existing user with unmatching token" do
		user = fb_user
		user.set_token("faketoken")
		User.expects(:find_by).with(facebookid: @@fbprofile["id"]).returns(user)
		Facebook.expects(:new).returns(stub(verify_token?: true))
		user.expects(:set_token)
		get(:login, {"facebookid" => user.facebookid, "token" => @@fbhash["access_token"]})
		assert_equal 200,response.status
	end

end