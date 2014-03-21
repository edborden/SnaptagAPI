require 'test_helper'

class UsersControllerTest < ActionController::TestCase

	test "show without token in header" do
		user = Fabricate(:user)
		get(:show, {"id" => user.id})
		assert_equal 401,response.status
	end

	test "show with invalid token in header" do
		user = Fabricate(:user)
		get(:show, {"id" => user.id},{ 'Authorization' => "Bearer 12345" })
		assert_equal 401,response.status
	end

	test "show with valid token in header" do
		user = Fabricate(:user)
		token = user.token
		get(:show, {"id" => user.id},{ 'Authorization' => "Bearer #{token}" })
		assert_equal user.email, json_response['user']['email']
	end

	test "new user, token exchange" do
		onetime_create_facebook_test_hash
		get(:create, {"facebookid" => @testuserprofile["id"], "token" => @testuserhash["access_token"]})
		assert_equal @testuserprofile["first_name"],User.first.firstname
		assert_equal @testuserprofile["first_name"],json_response['user']['firstname']
		assert_not_equal User.first.token,@testuserhash["access_token"]
	end

	test "existing user with matching token" do
		user = global_create_facebook_test_user
		get(:create, {"facebookid" => @@globaltestuserprofile["id"], "token" => @@globaltestuserhash["access_token"]})
		assert_equal @@globaltestuserprofile["first_name"],user.firstname
		assert_equal @@globaltestuserprofile["first_name"],json_response['user']['firstname']
	end

	test "existing user with unmatching token, token exchange" do
		user = onetime_create_facebook_test_user
		thetoken = user.token
		user.token = "123abc"
		user.save
		get(:create, {"facebookid" => @testuserprofile["id"], "token" => thetoken})
		assert_equal @testuserprofile["first_name"],User.first.firstname
		assert_equal @testuserprofile["first_name"],json_response['user']['firstname']
		assert_not_equal User.first.token,"123abc"
	end

end