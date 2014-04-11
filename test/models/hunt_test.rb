require 'test_helper'

class HuntTest < ActiveSupport::TestCase

	def setup
		2.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
		@web0 = Web.create(giver_id: @user0.id, receiver_id: @user1.id)
	end

	test "complete" do
		hunt = Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
		hunt.expects(:minus_one)
		hunt.complete
		assert hunt.active == false
	end

	test "ensure_matching_web" do
		assert_equal 1,Web.count
		hunt = Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
		assert_equal 1,Web.count
		@user2 = Fabricate(:user)
		hunt2 = Hunt.create(hunter_id: @user0.id, target_id: @user2.id)
		assert_equal 2,Web.count
		web2 = Web.last
		assert hunt2.matching_web
	end

	test "matching_web" do
		hunt = Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
		assert hunt.matching_web
		Web.first.destroy
		assert_not hunt.matching_web
	end

	test "make_room" do
		13.times {Fabricate(:user)}
		users = User.all
		users.delete_at(0)
		users.delete_at(0)
		users.each do |user|
			Web.create(giver_id: @user0.id, receiver_id: user.id)
		end
		assert_equal 14,Web.count
		assert_equal 14,@user0.reload.allwebs_count
		Hunt.new.make_room(@user0)
		assert_equal 10,Web.count
		assert_equal 10,@user0.reload.allwebs_count
	end

	test "plus_one, minus_one" do
		assert_equal 0,@user0.targets_count
		hunt = Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
		assert_equal 1,@user0.reload.targets_count
		hunt.minus_one
		assert_equal 0,@user0.reload.targets_count
	end

	test "counteract" do
		hunt = Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
		User.any_instance.expects(:compromise)
		User.any_instance.expects(:performed_counteraction)
		hunt.expects(:complete)
		hunt.counteract
		assert hunt.counteracted
	end
end
