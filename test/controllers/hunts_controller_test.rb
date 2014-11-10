require 'test_helper'

class HuntsControllerTest < ActionController::TestCase

	test "join" do
		queue = Activationqueue.create
		11.times { Fabricate(:user_with_location,activationqueue_id: queue.id) }
		user12 = Fabricate(:user,zone_id:nil)
		Blastoff.expects(:new).returns(stub(:run))
		Activationqueue.expects(:find_by).returns Activationqueue.first
		get(:join, {location:{lat: 10,lng: 10}},{'Authorization' => 'Bearer ' + user12.token})
		assert_equal 200,@response.status
		assert_equal 0,Activationqueue.count
		assert user12.reload.active
		assert user12.locations.exists?
		assert json_response["user"]
	end

end