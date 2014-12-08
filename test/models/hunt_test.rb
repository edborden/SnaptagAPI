require 'test_helper'

class HuntTest < ActiveSupport::TestCase

	def setup
		2.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user_with_location)) }
		@web0 = Web.create(giver_id: @user0.id, receiver_id: @user1.id)
	end

	test "ensure_matching_web" do
		assert_equal 1,Web.count
		hunt = Hunt.create(stalker_id: @user0.id, target_id: @user1.id)
		assert_equal 1,Web.count
		@user2 = Fabricate(:user)
		hunt2 = Hunt.create(stalker_id: @user0.id, target_id: @user2.id)
		assert_equal 2,Web.count
		web2 = Web.last
		assert hunt2.matching_web
	end

	test "matching_web" do
		hunt = Hunt.create(stalker_id: @user0.id, target_id: @user1.id)
		assert hunt.matching_web
		Web.first.destroy
		assert_not hunt.matching_web
	end

	test "plus_one, minus_one" do
		assert_equal 0,@user0.targets_count
		hunt = Hunt.create(stalker_id: @user0.id, target_id: @user1.id)
		assert_equal 1,@user0.reload.targets_count
		hunt.destroy
		assert_equal 0,@user0.reload.targets_count
	end

end
