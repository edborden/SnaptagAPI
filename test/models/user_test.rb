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

  test "user_is_not_already_hunting? returns true if input is not present in targets list" do
  #  user1 = Fabricate(:user)
  #  user2 = Fabricate(:user)
  #  hunt = Hunt.create(hunter_id: user1.id, target_id: user2.id)
  #  user3 = Fabricate(:user)
  #  assert_not user1.is_not_already_hunting?(user2), "should have returned false"
  #  assert user1.is_not_already_hunting?(user3), "should have returned true"
  #  assert user1 != user2, "should be true"
  #  assert user1 == user2
  end
  

end
