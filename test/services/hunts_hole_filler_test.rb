require 'test_helper'

class HuntsHoleFillerTest < ActiveSupport::TestCase

	def setup
		3.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
		@players = User.all
		@user3 = Fabricate :user
		@fillers = User.all
	end

	test "if is_it_time returning true and false correctly" do 
		assert_equal 4,User.all.need_stalkers.count
		assert_not HuntsHoleFiller.new(@players,[]).it_is_time?
		Activationqueue.create
		assert HuntsHoleFiller.new(@players,@fillers).it_is_time?
	end

	test "fill_hunt_holes" do
		assert_equal 4,User.need_stalkers.count
		HuntsHoleFiller.new(@players,@fillers).run
		assert_equal 2,Hunt.count
	end

end