ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

class ActiveSupport::TestCase

	def fbhash
		@@testuserapi ||= Koala::Facebook::TestUsers.new(app_id: 726528350693125, secret: "96ec2c1f6e53d6d1b4607164c190109c")
		@@fbhash ||= @@testuserapi.create(true)
	end

	def fbprofile
		@@fbprofile ||= Facebook.new(fbhash["access_token"]).get_profile
	end

	# create a test user that can be used across tests with gobal variable and doesn't keep pinging facebook
	def fbuser
		@user ||= User.create! do |user|
			user.facebookid = fbprofile["id"]
			user.name = fbprofile["first_name"]
			user.email = fbprofile["email"]
			user.gender = fbprofile["gender"]
		end
		@user.create_session token: fbhash["access_token"] unless @user.session
		@user
	end

	#parses full json response into hash
	def json_response
		@json_response ||= JSON.parse @response.body
	end
end
