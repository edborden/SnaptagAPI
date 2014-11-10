require 'test_helper'

class LocationsControllerTest < ActionController::TestCase

	test "create" do
		user = Fabricate(:user)
		post(:create, {location: {lat: Faker::Address.latitude, lng: Faker::Address.longitude}},{'Authorization' => 'Bearer ' + user.token})
		assert_equal 1,Location.count
		assert_equal 1,user.reload.stealth
	end
	
end