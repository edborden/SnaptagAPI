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

  test "is not already hunting" do
    assert_not @user1.is_not_already_hunting?(@user2)
    assert @user2.is_not_already_hunting?(@user1)
  end


end
