require 'test_helper'

class ZoneJoinerTest < ActiveSupport::TestCase

	def setup
		@z1 = Zone.create(lat:40.721923,lng:-74.007168,range:500)
		@z2 = Zone.create(lat:40.726216,lng:-73.976955,range:600)
	end

	test "join_zones" do
		10.times { Fabricate(:user, zone_id:@z2.id)}
		engulfed_user = Fabricate(:user, zone_id: @z1.id)
		GeoCalc.expects(:compute_containing_zone).returns(Zone.new(lat:10,lng:10,range:10))
		@z2.expects(:save)
		@z1.expects(:destroy)
		ZoneJoiner.new(@z1,@z2,true).run
		assert engulfed_user.reload.zone = @z2
		assert @z2.reload.grow_id = engulfed_user.id
	end

end