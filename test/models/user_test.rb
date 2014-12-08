require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		3.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
		Hunt.create(stalker_id: @user0.id, target_id: @user1.id)
	end

	test "user can list current stalkers and targets" do
		assert @user0.targets.include?(@user1)
		assert @user1.stalkers.include?(@user0)
		hunt = Hunt.find_by(target_id: @user1.id)
		hunt.active = false
		hunt.save
		assert_not @user1.stalkers.include?(@user0)
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

	test "activate, zone matches" do
		zone = Fabricate :zone
		@user0.locations.create lat:1,lng:1
		Zone.expects(:determine_zone_for).returns zone
		@user0.activate
		assert_equal @user0.zone,zone
		assert_not_nil @user0.activated_at
	end

	test "activate, no zone matches" do
		zone = Fabricate :zone
		@user0.locations.create lat:1,lng:1
		Zone.expects(:determine_zone_for).returns nil
		Zone.expects(:create_or_grow).returns zone
		@user0.activate
		assert_equal @user0.zone,zone
		assert_not_nil @user0.activated_at
	end

	test "expose_self" do
		@user0.expects(:increment!)
		@user0.expects(:deactivate)
		@user0.expose_self
	end

	test "deactivate deletes only active hunts" do
		testobject = "testobject"
		hunt_inactive = Hunt.create(stalker_id: @user0.id, target_id: @user2.id, active: false)
		assert_equal 2,Hunt.count
		@user0.expects(:zone).returns(testobject)
		testobject.expects(:remove_user).with(@user0)
		@user0.deactivate
		assert_equal 1,Hunt.count
	end

	test "remove_nonhunt_web" do
		nonhuntweb = Web.create(giver_id: @user0.id, receiver_id: @user2.id)
		assert @user0.reload.allwebs.include?(nonhuntweb)
		@user0.remove_nonhunt_web
		assert_not @user0.reload.allwebs.include?(nonhuntweb)
	end

	test "active" do
		assert @user0.active
		@user0.zone_id = nil
		assert_not @user0.active
	end

	test "create_from_facebook" do
		assert_equal 3,User.count
		Facebook.any_instance.expects(:get_pics).returns({smallpic: "smallpic",mediumpic: "mediumpic",largepic: "largepic"})
		user = User.create_from_facebook(fbhash["access_token"],fbhash)
		assert_equal 4,User.count
		assert_instance_of User,user
		assert_equal user.facebookid,fbhash["id"]
	end  

	test "status" do
		assert_equal "active",@user0.status
		@user0.zone_id = nil
		@user0.activationqueue_id = 1
		@user0.save
		assert_equal "queue",@user0.status
		@user0.activationqueue_id = nil
		@user0.save
		assert_equal "inactive",@user0.status
	end

	test "notify pushes notification" do
		@user1.notify "test","test",nil
		assert_equal 1,@user1.mailbox.notifications.count
	end

	test "make_room" do
		12.times {Fabricate(:user)}
		users = User.all - [@user0] - [@user1]
		users.each do |user|
			Web.create(giver_id: @user0.id, receiver_id: user.id)
		end
		assert_equal 14,Web.count
		assert_equal 14,@user0.reload.allwebs_count
		@user0.make_room
		assert_equal 10,Web.count
		assert_equal 10,@user0.reload.allwebs_count
	end

end