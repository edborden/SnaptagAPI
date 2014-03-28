ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


class ActiveSupport::TestCase
	ActiveRecord::Migration.check_pending!
	fixtures :all

	def fb_hash
		test_user_api ||= Koala::Facebook::TestUsers.new(:app_id => 726528350693125, :secret => "96ec2c1f6e53d6d1b4607164c190109c")
		@@fbhash ||= test_user_api.create(true)
		@@fbprofile ||= Facebook.new(@@fbhash["access_token"]).get_profile
	end

	# create a test user that can be used across tests with gobal variable and doesn't keep pinging facebook
	def fb_user
		fb_hash
		User.create! do |user|
			user.facebookid = @@fbprofile["id"]
			user.firstname = @@fbprofile["first_name"]
			user.lastname = @@fbprofile["last_name"]
			user.token = @@fbhash["access_token"]
			user.email = @@fbprofile["email"]
			user.gender = @@fbprofile["gender"]
		end
	end

	#parses full json response into hash
	def json_response
		@json_response ||= JSON.parse @response.body
	end
end
