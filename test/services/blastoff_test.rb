require 'test_helper'

class BlastoffTest < ActiveSupport::TestCase
	def setup
		3.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
		@queue = [@user0,@user1,@user2]
	end

	test "assign_a_target assigns a target" do
		Blastoff.new(@queue).assign_a_target(@user0,@queue)
		assert_equal true,Hunt.exists?
	end

	test "find_a_valid_target_in_list returns 3rd record in list if first two records are invalid" do
		Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
		result = Blastoff.new(@queue).find_a_valid_target_in_list(@user0,@queue)
		assert_equal result,@user2,"Did not return third user"
		result = Blastoff.new(@queue).find_a_valid_target_in_list(@user2,@queue)
		assert_equal result,@user0,"Did not return first user"
	end

	test "take_target_off_list_if_has_enough_hunters works" do
		@user0.hunters_count = 3
		Blastoff.new(@queue).take_target_off_list_if_has_enough_hunters(@user0,@queue)
		assert_not @queue.include?(@user0)
	end

	test "blastoff creates 36 relationships" do
		# Sending 12 total users, 3 from setup and 9 from this method
		9.times {Fabricate(:user)}
		mock_activation_queue = User.all
		Blastoff.new(mock_activation_queue).run
		assert_equal 36,Hunt.count
	end

end