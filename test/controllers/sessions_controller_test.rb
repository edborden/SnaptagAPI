require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
	test "facebook test user is working" do
	    create_facebook_test_user
	    post(:create, {"id" => @profile["id"],"token" => @testuserhash["access_token"]})
	    assert_response :accepted
		assert_not_nil session[:user_id]
		assert_not_nil session[:token]
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
end