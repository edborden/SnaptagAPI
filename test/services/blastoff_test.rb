require 'test_helper'

class BlastoffTest < ActiveSupport::TestCase

	def setup
		@queue = 12.times { Fabricate(:user) }
	end

	test "assign_a_target assigns a target" do
	end

	test "find_a_valid_target_in_list returns 3rd record in list if first two records are invalid" do
	#	user1 = Fabricate(:user)
	#	user2 = Fabricate(:user)
	#	user3 = Fabricate(:user)
	#	queue = [user1,user2,user3]
	#	blastoff = Blastoff.new(queue)
	#	blastoff.find_a_valid_target_in_list()

	end

	test "take_target_off_list_if_has_enough_hunters works" do
	end

end