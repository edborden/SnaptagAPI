require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "users are created and default to inactive" do
  	user=users(:user1) 	assert_equal user.active, false
 	assert_equal user.name, nil
  end

end
