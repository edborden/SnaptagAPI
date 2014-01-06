require 'test_helper'

class BlastoffTest < ActiveSupport::TestCase
	def setup
		@user1 = Fabricate(:user)
		@user2 = Fabricate(:user)
		@user3 = Fabricate(:user)
		@queue = [@user1,@user2,@user3]
	end

	test "assign_a_target assigns a target" do
		Blastoff.new(@queue).assign_a_target(@user1,@queue)
		assert_equal Hunt.exists?,1
	end

	test "find_a_valid_target_in_list returns 3rd record in list if first two records are invalid" do
		Hunt.create(hunter_id: @user1.id, target_id: @user2.id)
		result = Blastoff.new(@queue).find_a_valid_target_in_list(@user1,@queue)
		assert_equal result,@user3,"Did not return third user"
		result = Blastoff.new(@queue).find_a_valid_target_in_list(@user3,@queue)
		assert_equal result,@user1,"Did not return first user"
	end

	test "take_target_off_list_if_has_enough_hunters works" do
		@user1.hunters_count = 3
		Blastoff.new(@queue).take_target_off_list_if_has_enough_hunters(@user1,@queue)
		assert_not @queue.include?(@user1)
	end

	test "blastoff creates 36 relationships" do
		# Sending 12 total users, 3 from setup and 9 from this method
		9.times {Fabricate(:user)}
		mock_activation_queue = User.all
		Blastoff.new(mock_activation_queue).run
		assert_equal 36,Hunt.count
	end

end