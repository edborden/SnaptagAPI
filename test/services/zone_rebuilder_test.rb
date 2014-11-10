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

	test "integration, all users tight together within defaultmaxdistance" do
		Fabricate.times(25,:user_in_nyc, zone_id:@zone.id)
		original_lat = @zone.lat
		original_lng = @zone.lng
		original_range = @zone.range
		response = ZoneRebuilder.new(@zone).run
		assert_equal original_lat,response.lat
		assert_equal original_lng,response.lng
		assert_not_equal original_range,response.range
	end

	test "integration" do
		Fabricate.times(25,:user_with_location, zone_id:@zone.id)
		original_lat = @zone.lat
		original_lng = @zone.lng
		original_range = @zone.range
		response = ZoneRebuilder.new(@zone).run
		assert_not_equal original_lat,response.lat
		assert_not_equal original_lng,response.lng
		assert_not_equal original_range,response.range
	end

end