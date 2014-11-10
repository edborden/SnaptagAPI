require 'test_helper'

class WebTest < ActiveSupport::TestCase

	def setup
		2.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user_with_location)) }
		@web0 = Web.create(giver_id: @user0.id, receiver_id: @user1.id)
	end

	test "giver,receiver" do
		assert_equal @web0.giver,@user0
		assert_equal @web0.receiver,@user1
	end

	test "matching_hunt" do
		hunt = Hunt.create(stalker_id:@user0.id,target_id:@user1.id)
		assert_equal hunt,@web0.matching_hunt
		hunt.stalker_id = @user1.id
		hunt.target_id = @user0.id
		hunt.save
		assert_equal hunt,@web0.matching_hunt
	end

	test "plus_one and minus_one" do
		Web.any_instance.expects(:plus_one)
		Web.any_instance.expects(:minus_one)
		@web0.destroy
		Web.create(giver_id: @user0.id, receiver_id: @user1.id)
	end

end