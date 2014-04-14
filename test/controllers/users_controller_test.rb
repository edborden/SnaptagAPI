require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	#test "api call with unmatching token" do
	#	get(:me, {"token" => "faketoken"})
	#	assert_equal 401,response.status
	#end

	test "me with valid token" do
		user = Fabricate(:user)
		get(:me, {"token" => user.token})
		assert_equal 200,response.status
		assert_equal user.firstname, json_response['user']['firstname']
	end

	test "new user" do
		fb_hash
		User.expects(:find_by).with(facebookid: @@fbhash["id"]).returns(nil)
		Facebook.any_instance.expects(:exchange_token).returns("newtoken")
		Facebook.any_instance.expects(:get_profile).returns(@@fbhash)
		User.expects(:create_from_facebook).with("newtoken",@@fbhash)
		get(:login, {"token" => @@fbhash["access_token"]})
		assert_equal 200,@response.status
	end

end