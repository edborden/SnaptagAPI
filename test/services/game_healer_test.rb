require 'test_helper'

class GameHealerTest < ActiveSupport::TestCase

	def setup
		@zone = Fabricate :zone
		15.times { Fabricate :user, zone_id: @zone.id }
	end

	test "all of it, small" do
		GameHealer.new(@zone).run
		assert_equal 0, User.where("stalkers_count > 1").count
		assert_equal 0, User.where("targets_count > 1").count
		assert_equal 15, Hunt.count
	end

	test "all of it, with queue" do
		GameHealer.new(@zone).run
		activationqueue = Activationqueue.create(zone_id: @zone.id)
		2.times { Fabricate :user, zone_id: @zone.id, activationqueue_id: activationqueue.id }
		GameHealer.new(@zone).run
		assert_equal 0, User.where("stalkers_count < 1").count
		assert_equal 0, User.where("targets_count < 1").count
		assert_not Activationqueue.exists?
	end

end