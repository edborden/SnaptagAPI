require 'test_helper'

class WebsHoleFillerTest < ActiveSupport::TestCase

	def setup
		12.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
	end

	test "currently_webbed" do
		Web.create(giver_id: @user0.id, receiver_id: @user1.id)
		Web.create(giver_id: @user2.id, receiver_id: @user0.id)
		assert WebsHoleFiller.new(@user0).currently_webbed,[@user1,@user2]
		Web.create(giver_id: @user3.id, receiver_id: @user0.id)
		assert WebsHoleFiller.new(@user0).currently_webbed,[@user1,@user2,@user3]
	end

	test "need_givers" do
		Web.create(giver_id: @user0.id, receiver_id: @user1.id)
		assert WebsHoleFiller.new(@user0).need_givers,User.all - [@user0,@user1]
	end

	test "time_to_stop?" do
		@user0.givers_count = 6
		@user0.receivers_count = 5
		@user0.save
		assert_equal 11,@user0.reload.allwebs_count
		assert WebsHoleFiller.new(@user0).time_to_stop?
		@user0.givers_count = 5
		@user0.save
		assert_not WebsHoleFiller.new(@user0).time_to_stop?
		WebsHoleFiller.any_instance.expects(:need_givers).returns([])
		WebsHoleFiller.any_instance.expects(:need_receivers).returns([])
		assert WebsHoleFiller.new(@user0).time_to_stop?
	end

	test "fill_web_hole" do

	end

	test "all of it" do
		Web.create(giver_id: @user0.id, receiver_id: @user1.id)
		WebsHoleFiller.new(@user0).run
		assert 11,@user0.allwebs_count
		assert_equal 11,Web.count
	end

end