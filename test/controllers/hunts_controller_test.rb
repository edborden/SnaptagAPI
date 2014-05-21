require 'test_helper'

class HuntsControllerTest < ActionController::TestCase

	test "intro_map" do
	end

	test "join when blastoff runs returns active" do
		queue = Activationqueue.create
		11.times { Fabricate(:user_with_location,activationqueue_id: queue.id) }
		user12 = Fabricate(:user_with_location,zone_id:nil)
		get(:join, {"token" => user12.token,"lat" => "10","lon" => "10","accuracy" => "10","timestamp" => "1234"})
		assert_equal 0,Activationqueue.count
		assert_equal "active",@response.body
	end

end