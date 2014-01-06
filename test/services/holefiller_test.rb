require 'test_helper'

class HolefillerTest < ActiveSupport::TestCase

	def setup
		3.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
	end

	test "if is_it_time returning true and false correctly" do 
	assert_equal 3,User.all.active.need_hunters.count
	assert_not Holefiller.new.it_is_time?
	Activationqueue.create
	assert Holefiller.new.it_is_time?
	end

	test "get_new_player returns a player on the activation queue" do
		activationqueue = Activationqueue.create
		User.all.each {|user| user.activationqueue_id=activationqueue.id}
		assert activationqueue.users.include?(@user0), "should include user0"
		assert activationqueue.users.include?(Holefiller.new.get_new_player)
	end

end