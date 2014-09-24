require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

	test "login, new user" do
		Facebook.expects(:new).with(fbhash["access_token"]).returns(stub(exchange_token: "newtoken",get_profile: fbhash))
		User.expects(:find_by).with(facebookid: fbhash["id"]).returns(nil)
		User.expects(:create_from_facebook).with("newtoken",fbhash).returns(User.new)
		get(:show,{id: fbhash["access_token"]})
		assert_equal 200,@response.status
	end

	test "login, new user, bad token" do
		# this won't work because of erroring out from facebook exchange token call
	end

	test "login existing user" do
		user = fbuser
		Facebook.expects(:new).with(fbhash["access_token"]).returns(stub(exchange_token: "newtoken",get_profile: fbhash))
		User.expects(:find_by).with(facebookid: user.facebookid).returns(user)
		user.expects(:session).returns(nil)
		user.expects(:create_session).with(token: "newtoken").returns(Session.new user_id: user.id)
		get(:show, {id: fbhash["access_token"]})
		assert_equal 200,@response.status
	end
	
end