require 'test_helper'

class LocationsControllerTest < ActionController::TestCase

	test "update" do
		user = Fabricate(:user)
		params = {}
		params[:latitude] = Faker::Address.latitude
		params[:longitude] = Faker::Address.longitude
		params[:accuracy] = 40
		params[:timestamp] = "1236"
		params[:token] = user.token
		get(:update, params)
		assert_equal 1,Location.count
		location = Location.first
		assert_equal location.timestamp,params[:timestamp]
		assert_equal 1,user.reload.influence
	end



end