ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

class ActiveSupport::TestCase
	ActiveRecord::Migration.check_pending!
	fixtures :all

	def onetime_create_facebook_test_hash
		test_user ||= Koala::Facebook::TestUsers.new(:app_id => 726528350693125, :secret => "96ec2c1f6e53d6d1b4607164c190109c")
		@testuserhash = test_user.create(true)
		@testuserprofile = Facebook.new.get_profile(@testuserhash["access_token"])
	end


	# create a test user that is used in only one test (token gets swapped)
	def onetime_create_facebook_test_user
		onetime_create_facebook_test_hash
		User.create! do |user|
			user.facebookid = @testuserprofile["id"]
			user.firstname = @testuserprofile["first_name"]
			user.lastname = @testuserprofile["last_name"]
			user.token = @testuserhash["access_token"]
			user.email = @testuserprofile["email"]
			user.gender = @testuserprofile["gender"]
		end
	end

	def global_create_facebook_test_hash
		test_user_api ||= Koala::Facebook::TestUsers.new(:app_id => 726528350693125, :secret => "96ec2c1f6e53d6d1b4607164c190109c")
		@@globaltestuserhash ||= test_user_api.create(true)
		@@globaltestuserprofile ||= Facebook.new.get_profile(@@globaltestuserhash["access_token"])
	end

	# create a test user that can be used across tests with gobal variable and doesn't keep pinging facebook
	def global_create_facebook_test_user
		global_create_facebook_test_hash
		User.create! do |user|
			user.facebookid = @@globaltestuserprofile["id"]
			user.firstname = @@globaltestuserprofile["first_name"]
			user.lastname = @@globaltestuserprofile["last_name"]
			user.token = @@globaltestuserhash["access_token"]
			user.email = @@globaltestuserprofile["email"]
			user.gender = @@globaltestuserprofile["gender"]
		end
	end

	#parses full json response into hash
	def json_response
		@json_response ||= JSON.parse @response.body
	end
end
