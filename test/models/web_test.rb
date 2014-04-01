require 'test_helper'

class WebTest < ActiveSupport::TestCase

	def setup
		5.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
		Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
		Hunt.create(hunter_id: @user0.id, target_id: @user2.id)
	end
	
	## THIS NEEDS EXCEPTION HANDLING
	test "user should not be able to have more than 3 hunters or targets" do
		skip
		Hunt.create(hunter_id: @user0.id, target_id: @user3.id)
		Hunt.create(hunter_id: @user0.id, target_id: @user4.id)
		assert_equal 3,Hunt.count
		Hunt.create(hunter_id: @user1.id, target_id: @user0.id)
		Hunt.create(hunter_id: @user2.id, target_id: @user0.id)
		Hunt.create(hunter_id: @user3.id, target_id: @user0.id)
		Hunt.create(hunter_id: @user4.id, target_id: @user0.id)
		assert_equal 6,Hunt.count
	end

	test "deactivate_hunt" do
	end

	test "complete" do
	end

	test "has_a_hunt?" do
	end

end
