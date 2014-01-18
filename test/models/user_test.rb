require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user1 = Fabricate(:user)
    @user2 = Fabricate(:user)
    Hunt.create(hunter_id: @user1.id, target_id: @user2.id)
  end

  test "user can list hunters and targets" do
    assert @user1.targets.include?(@user2)
    assert @user2.hunters.include?(@user1)
  end

  test "user should not be able to have more than 3 hunters or targets" do

  end

  test "inactive user cannot have relationships or be added to the queue" do
  end 

  test "facebook test user is working" do
    @test_users ||= Koala::Facebook::TestUsers.new(:app_id => 726528350693125, :secret => "96ec2c1f6e53d6d1b4607164c190109c")
    testuserhash = @test_users.create(true)
    profile = Koala::Facebook::API.new(testuserhash["access_token"]).get_object("me")
    User.create! do |user|
      user.facebookid = profile["id"]
      user.firstname = profile["firstname"]
      user.lastname = profile["lastname"]
      user.token = testuserhash["access_token"]
      user.email = profile["email"]
      user.gender = profile["gender"]
    end
  end

  

end


