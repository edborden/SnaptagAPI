require 'test_helper'

class ActionsControllerTest < ActionController::TestCase

	test "join" do
		zone = Fabricate :zone
		queue = Activationqueue.create zone_id: zone.id
		3.times { Fabricate(:user_with_location,activationqueue_id: queue.id, zone_id: zone.id) }
		user4 = Fabricate(:user,zone_id:nil)
		#Blastoff.expects(:new).returns(stub(:run))
		get(:join, {location:{lat: zone.lat,lng: zone.lng}},{'Authorization' => 'Bearer ' + user4.token})
		assert_equal 204,@response.status
		assert_equal 0,Activationqueue.count
		assert user4.reload.active
		assert user4.locations.exists?
	end

end