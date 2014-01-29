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
    skip
    create_facebook_test_user
    assert_instance_of User,user
  end

  test "from_mobile calls its methods" do
     facebookid = 123
     token = 456
    User.expects(:find_by).returns(false)
    User.expects(:create_from_facebook).with(token)
    User.from_mobile(facebookid,token)
  end

  test "exchange_token doesn't return the same token" do
    user = create_facebook_test_user
    oldtoken = user.token
    newtoken = user.exchange_token
    assert_instance_of String,newtoken
    assert_not_equal oldtoken,user.reload.token
  end

end


