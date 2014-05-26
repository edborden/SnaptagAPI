require 'test_helper'

class HuntEnderTest < ActiveSupport::TestCase
	def setup
		2.times { |n| instance_variable_set("@user" + n.to_s, Fabricate(:user_with_location)) }
		@hunt = Hunt.create(hunter_id: @user0.id, target_id: @user1.id)
	end

	test "expose_success" do 
		
	end

end