require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		2.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
		Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
	end

	test "user can list current hunters and targets" do
		assert @user0.current_targets.include?(@user1)
		assert @user1.current_hunters.include?(@user0)
		hunt = Hunt.find_by(target_id: @user1.id)
		hunt.active = false
		hunt.save
		assert_not @user1.current_hunters.include?(@user0)
	end

	test "inactive user cannot have relationships or be added to the queue" do
	end 

	test "create_from_facebook" do
		global_create_facebook_test_hash
		user = User.create_from_facebook(@@globaltestuserhash["access_token"])
		assert_instance_of User,user
	end  

	test "active? and activate work" do
		@user0.active = false
		@user0.save
		assert_not @user0.active, "test didn't set up properly"
		assert_not @user0.active?, "user is still active"
		@user0.activate
		assert @user0.active?, "user didn't activate"
	end

end