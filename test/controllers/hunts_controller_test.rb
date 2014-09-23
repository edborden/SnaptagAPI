require 'test_helper'

class HuntsControllerTest < ActionController::TestCase

	test "join when blastoff runs returns active" do
		queue = Activationqueue.create
		11.times { Fabricate(:user_with_location,activationqueue_id: queue.id) }
		user12 = Fabricate(:user_with_location,zone_id:nil)
		Blastoff.expects(:new).returns(stub(:run))
		get(:join, {location:{lat: 10,lon: 10}},{'Authorization' => 'Bearer ' + user12.token})
		assert_equal 200,@response.status
		assert_equal 0,Activationqueue.count
		assert user12.reload.active?
		assert_equal "active",@response.body
	end

end