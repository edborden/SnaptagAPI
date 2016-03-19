require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

	test "create" do
		Facebook.expects(:new).with(fbhash["access_token"]).returns(stub(exchange_token: "newtoken",profile: fbhash,create_user: User.new,facebookid: fbhash["id"]))
		User.expects(:find_by).with(facebookid: fbhash["id"]).returns(nil)
		get(:create,{session: {token: fbhash["access_token"]}})
		assert_equal 200,@response.status
	end

	test "index existing user" do
		get(:index, {token: fbuser.token})
		assert_equal json_response["sessions"][0]["id"], fbuser.session.id
		assert_equal 200,@response.status
	end
	
end