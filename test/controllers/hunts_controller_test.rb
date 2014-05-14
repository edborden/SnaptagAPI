require 'test_helper'

class HuntsControllerTest < ActionController::TestCase

	test "intro_map" do
	end

	test "join when blastoff runs returns active" do
		queue = Activationqueue.create
		11.times { Fabricate(:user_with_location,activationqueue_id: queue.id) }
		user12 = Fabricate(:user_with_location,active: false)
		get(:join, {"token" => user12.token})
		assert_equal 0,Activationqueue.count
		assert_equal "active",@response.body
	end

end