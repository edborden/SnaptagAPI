require 'test_helper'

class WebsHoleFillerTest < ActiveSupport::TestCase

	def setup
		zone = Fabricate :zone
		12.times do |n|
			user = Fabricate :user
			user.zone = zone
			user.save
			instance_variable_set("@user" + n.to_s, user)
		end
	end

	test "fill_web_hole" do

	end

	test "all of it" do
		Web.create(giver_id: @user0.id, receiver_id: @user1.id)
		WebsHoleFiller.new(@user0.reload).run
		assert 11,@user0.allwebs_count
		assert_equal 11,Web.count
	end

end