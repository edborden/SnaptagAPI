require 'test_helper'

class WebTest < ActiveSupport::TestCase

	def setup
		5.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user)) }
		Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
		Hunt.create(hunter_id: @user0.id, target_id: @user2.id)
	end
	
	test "deactivate_hunt" do
	end

	test "complete" do
	end

	test "has_a_hunt?" do
	end

end
