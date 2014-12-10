require 'test_helper'

class HuntsHoleFillerTest < ActiveSupport::TestCase

	def setup
		4.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
	end

	test "if is_it_time returning true and false correctly" do 
		assert_equal 4,User.all.need_stalkers.count
		assert_not HuntsHoleFiller.new.it_is_time?
		Activationqueue.create
		assert HuntsHoleFiller.new.it_is_time?
	end

	test "lucky_player returns a player on the activation queue" do
		queue = Activationqueue.create
		User.all.each do |user|
			queue.users<<(user)
		end
		assert queue.users.include?(HuntsHoleFiller.new.lucky_player)
	end

	test "fill_hunt_holes" do
		queue = Activationqueue.create
		queue.users<<(@user3)
		assert_equal 4,User.count
		assert_equal 3,User.need_stalkers.count
		HuntsHoleFiller.new.fill_hunt_holes(@user3)
		assert_equal 6,Hunt.count
		assert_equal 3,@user3.stalkers.count
	end

	test "the whole enchilada" do
		queue = Activationqueue.create
		@user3.activationqueue_id = queue.id
		@user3.save
		HuntsHoleFiller.new.run
		assert_equal 6,Hunt.count
	end

end