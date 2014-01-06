require 'test_helper'

class UserTest < ActiveSupport::TestCase

test "users are 12 users in the test database which default to inactive" do
   12.times { Fabricate(:user) }
   assert User.count == 12
   assert_equal Fabricate(:user).active, false
  end

  test "user can list relations and inverse relations" do

  end

  test "user should not be able to have more than 3 hunters or targets" do

  end

  test "inactive user cannot have relationships or be added to the queue" do
  end 

  test "is not already hunting" do
  user1 = Fabricate(:user)
  user2 = Fabricate(:user)
  Hunt.create(hunter_id: user1.id, target_id: user2.id)
  assert_not user1.is_not_already_hunting?(user2)
  assert user2.is_not_already_hunting?(user1)
  end


end
