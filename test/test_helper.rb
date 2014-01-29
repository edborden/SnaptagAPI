ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
end

def create_facebook_test_user
	@test_users ||= Koala::Facebook::TestUsers.new(:app_id => 726528350693125, :secret => "96ec2c1f6e53d6d1b4607164c190109c")
    @testuserhash = @test_users.create(true)
    @profile = Koala::Facebook::API.new(@testuserhash["access_token"]).get_object("me")
	User.create! do |user|
      user.facebookid = @profile["id"]
      user.firstname = @profile["firstname"]
      user.lastname = @profile["lastname"]
      user.token = @testuserhash["access_token"]
      user.email = @profile["email"]
      user.gender = @profile["gender"]
    end
end

def json_response
    @json_response ||= ActiveSupport::JSON.decode @response.body
end
