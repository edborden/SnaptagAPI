require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    5.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
    Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
  end

  test "user can list hunters and targets" do
    assert @user0.targets.include?(@user1)
    assert @user1.hunters.include?(@user0)
  end

  test "user can list only active or inactive hunters and targets" do
    skip
    assert @user0.targets.include?(@user1)
    assert @user1.hunters.include?(@user0)
  end

  test "user should not be able to have more than 3 hunters or targets" do
    Hunt.create(hunter_id: @user0.id, target_id: @user2.id)
    Hunt.create(hunter_id: @user0.id, target_id: @user3.id)
    Hunt.create(hunter_id: @user0.id, target_id: @user4.id)
    assert
    Hunt.create(hunter_id: @user1.id, target_id: @user0.id)
    Hunt.create(hunter_id: @user2.id, target_id: @user0.id)
    Hunt.create(hunter_id: @user3.id, target_id: @user0.id)
    Hunt.create(hunter_id: @user4.id, target_id: @user0.id)
    assert

  end

  test "inactive user cannot have relationships or be added to the queue" do
  end 

  test "create_from_facebook" do
  end  

end


