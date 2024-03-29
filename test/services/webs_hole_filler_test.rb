require 'test_helper'

class WebsHoleFillerTest < ActiveSupport::TestCase

	def setup
		@zone = Fabricate :zone
		6.times do |n|
			user = Fabricate :user, zone_id: @zone.id
			instance_variable_set("@user" + n.to_s, user)
		end
	end

	test "fill_web_hole" do

	end

	test "all of it" do
		WebsHoleFiller.new(@user0).run
		assert 5,@user0.allwebs_count
		assert_equal 5,Web.count
		@user0.reload
		assert_equal 5,@user0.allwebs.count
		assert_not_equal 0,@user0.receivers_count
		assert_not_equal 0,@user0.givers_count
		assert_not_equal 5,@user0.receivers_count
		assert_not_equal 5,@user0.givers_count
		filler = WebsHoleFiller.new(@user0)
		assert filler.need_givers.blank?
		assert filler.need_receivers.blank?
		filler.run
		assert_equal 5,Web.count		
		3.times do |n|
			user = Fabricate :user, zone_id: @zone.id
		end
		WebsHoleFiller.new(@user0).run
		assert_equal 8,Web.count		
	end

end