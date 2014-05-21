require 'test_helper'

class ZoneRebuilderTest < ActiveSupport::TestCase

	def setup
		@zone = Fabricate(:zone_in_nyc)
	end

	test "get_users_not_in_zone" do 		

		nycuser = Fabricate(:user_in_nyc, zone_id:@zone.id)
		londonuser = Fabricate(:user_in_london)
		list = [nycuser,londonuser]
		assert_equal [londonuser],ZoneRebuilder.new.get_users_not_in_zone(list,@zone)
	end

	test "integration"
		zone = Fabricate(:zone_in_nyc, range:100000)
		100.times {Fabricate(:user_in_nyc, zone_id:zone.id) }
		original_zone = zone
		assert_not_equal original_zone,ZoneRebuilder.new(zone).run
	end

end