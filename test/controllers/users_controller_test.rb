require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	test "returns json user" do
		user = Fabricate(:user)
		session[:user_id] = user.id
		get(:show)
		assert_equal user.email, json_response['email']
	end

end