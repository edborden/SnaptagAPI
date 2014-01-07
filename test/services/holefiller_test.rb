require 'test_helper'

class HolefillerTest < ActiveSupport::TestCase

	def setup
		4.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
	end

	test "if is_it_time returning true and false correctly" do 
	assert_equal 4,User.all.need_hunters.count
	assert_not Holefiller.new.it_is_time?
	Activationqueue.create
	assert Holefiller.new.it_is_time?
	end

	test "get_new_player returns a player on the activation queue" do
		activationqueue = Activationqueue.create
		User.all.each do |user|
			user.activationqueue_id=activationqueue.id
			user.save
		end
		assert activationqueue.users.include?(@user0), "should include user0"
		assert activationqueue.users.include?(Holefiller.new.get_new_player)
	end

	test "fill_hunt_holes" do
		activationqueue = Activationqueue.create
		@user3.activationqueue_id = activationqueue.id
		@user3.save
		assert_equal 4,User.count
		assert_equal 3,User.need_hunters.count
		Holefiller.new.fill_hunt_holes(@user3)
		assert_equal 6,Hunt.count
		assert_equal 3,@user3.hunters.count
	end

	test "the whole enchilada" do
		activationqueue = Activationqueue.create
		@user3.activationqueue_id = activationqueue.id
		@user3.save
		Holefiller.new.run
		assert_equal 6,Hunt.count
	end

end