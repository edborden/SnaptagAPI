ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
	ActiveRecord::Migration.check_pending!
	fixtures :all

	# create a test user that is used in only one test (token gets swapped)
	def dump_create_facebook_test_user
		test_user ||= Koala::Facebook::TestUsers.new(:app_id => 726528350693125, :secret => "96ec2c1f6e53d6d1b4607164c190109c")
	    testuserhash = test_user.create(true)
	    profile = Facebook.new.get_profile(testuserhash["access_token"])
		User.create! do |user|
	      user.facebookid = profile["id"]
	      user.firstname = profile["first_name"]
	      user.lastname = profile["last_name"]
	      user.token = testuserhash["access_token"]
	      user.email = profile["email"]
	      user.gender = profile["gender"]
	    end
	end

	# create a test user that can be used across tests with gobal variable and doesn't keep pinging facebook
	def global_create_facebook_test_user
		test_user_api ||= Koala::Facebook::TestUsers.new(:app_id => 726528350693125, :secret => "96ec2c1f6e53d6d1b4607164c190109c")
	    @@globaltestuserhash ||= test_user_api.create(true)
	    @@globaltestuserprofile ||= Facebook.new.get_profile(@@globaltestuserhash["access_token"])
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
	    @json_response ||= ActiveSupport::JSON.decode @response.body
	end
end
