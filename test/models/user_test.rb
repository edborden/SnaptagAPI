require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		3.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
		Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
	end

	test "user can list current hunters and targets" do
		assert @user0.targets.include?(@user1)
		assert @user1.hunters.include?(@user0)
		hunt = Hunt.find_by(target_id: @user1.id)
		hunt.active = false
		hunt.save
		assert_not @user1.hunters.include?(@user0)
	end

	test "allwebs_count" do
		@user0.expects(:givers_count).returns(2)
		@user0.expects(:receivers_count).returns(3)
		assert_equal 5,@user0.allwebs_count
	end

	test "allwebs" do
		@user0.antiwebs.create(giver_id: @user2.id)
		assert @user0.webs.count == 0 || @user0.webs.count == 1
		assert @user0.antiwebs.count == 1 || @user0.antiwebs.count == 2
		assert_equal 2,@user0.allwebs.count
	end

	test "active? and activate work" do
		@user0.active = false
		@user0.save
		assert_not @user0.active, "test didn't set up properly"
		@user0.activate
		assert @user0.active?, "user didn't activate"
	end

	test "deactivate deletes only active hunts" do
		hunt_inactive = Hunt.create(hunter_id: @user0.id, target_id: @user2.id, active: false)
		assert_equal 2,Hunt.count
		@user0.deactivate
		assert_equal 1,Hunt.count
	end

	test "remove_nonhunt_web" do
		nonhuntweb = Web.create(giver_id: @user0.id, receiver_id: @user2.id)
		assert @user0.reload.allwebs.include?(nonhuntweb)
		@user0.remove_nonhunt_web
		assert_not @user0.reload.allwebs.include?(nonhuntweb)
	end

	test "create_from_facebook" do
		fb_hash
		assert_equal 3,User.count
		Facebook.any_instance.expects(:get_pics).returns({smallpic: "smallpic",mediumpic: "mediumpic",largepic: "largepic"})
		user = User.create_from_facebook(@@fbhash["access_token"],fb_hash)
		assert_equal 4,User.count
		assert_instance_of User,user
		assert_equal user.facebookid,@@fbhash["id"]
	end  

	test "set_token" do
		@user0.set_token("123abc")
		assert_equal "123abc",@user0.token
	end

	test "latest_location" do
	end

end