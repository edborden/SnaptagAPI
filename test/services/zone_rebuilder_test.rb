require 'test_helper'

class ZoneRebuilderTest < ActiveSupport::TestCase

	def setup
		@zone = Fabricate(:zone_in_nyc,range:100000)
	end

	test "get_users_not_in_zone" do
		nycuser = Fabricate(:user_in_nyc, zone_id:@zone.id)
		londonuser = Fabricate(:user_in_london)
		list = [nycuser,londonuser]
		assert_equal [londonuser],ZoneRebuilder.new.get_users_not_in_zone(list,@zone)
	end

	test "integration" do
		Fabricate.times(25,:user_in_nyc, zone_id:@zone.id)
		original_zone_range = @zone.range
		assert_not_equal original_zone_range,ZoneRebuilder.new(@zone).run.range
	end

end