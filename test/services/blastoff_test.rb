require 'test_helper'

class BlastoffTest < ActiveSupport::TestCase
	def setup
		12.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
		@queue = [@user0,@user1,@user2,@user3]
	end

	test "find_a_valid_target_in_list" do
		Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
		assert_equal @user2,Blastoff.new.find_a_valid_target_in_list(@user0,@queue),"Did not return third user"
		assert_equal @user0,Blastoff.new.find_a_valid_target_in_list(@user2,@queue),"Did not return first user"
	end

	test "assign_a_target creates a hunt" do
		Blastoff.new.assign_target(@user0,@queue)
		assert_equal true,Hunt.exists?
	end

#	test "assign_a_target removes"

	test "find_a_valid_web_target_in_list" do
		Web.create(giver_id: @user0.id, receiver_id: @user1.id)
		Web.create(giver_id: @user2.id, receiver_id: @user0.id)
		assert_equal @user3,Blastoff.new.find_a_valid_web_target_in_list(@user0,@queue),"Did not return fourth user"
		assert_equal @user0,Blastoff.new.find_a_valid_web_target_in_list(@user3,@queue),"Did not return first user"
	end

	test "assign_receiver" do
		Blastoff.any_instance.expects(:find_a_valid_web_target_in_list).returns(@user0)
		Web.expects(:create).with(giver_id: @user1.id, receiver_id: @user0.id)
		Blastoff.new.assign_receiver(@user1,[@user0,@user1])
	end

	test "blastoff creates 36 relationships,72 webs" do
		mock_activation_queue = User.all
		Blastoff.new(mock_activation_queue).run
		assert_equal 36,Hunt.count
		assert_equal 66,Web.count
		mock_activation_queue.each do |user|
			assert_equal 3, user.reload.hunters_count
			assert_equal 3, user.targets_count
			assert user.givers_count == 5 || user.givers_count == 6
			assert user.receivers_count == 5 || user.receivers_count == 6
		end
	end

end