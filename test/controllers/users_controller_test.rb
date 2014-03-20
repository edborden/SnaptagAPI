require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	test "returns json user" do
		user = Fabricate(:user)
		session[:user_id] = user.id
		get(:show)
		assert_equal user.email, json_response['email']
	end

	test "should create user" do
		@test_users ||= Koala::Facebook::TestUsers.new(:app_id => 726528350693125, :secret => "96ec2c1f6e53d6d1b4607164c190109c")
    	@testuserhash = @test_users.create(true)
    	@profile = Koala::Facebook::API.new(@testuserhash["access_token"]).get_object("me")
		post(:create, {"id" => @profile["id"],"token" => @testuserhash["access_token"]})
		assert_response :accepted
		assert_not_nil session[:user_id]
		assert_not_nil session[:token]
	end

	test "from_mobile calls its methods" do
		facebookid = 123
		token = 456
		User.expects(:find_by).returns(false)
		User.expects(:create_from_facebook).with(token)
		User.from_mobile(facebookid,token)
  end

end