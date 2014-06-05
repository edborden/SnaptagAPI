require 'test_helper'

class LocationsControllerTest < ActionController::TestCase

	test "update" do
		user = Fabricate(:user)
		params = {}
		params[:lat] = Faker::Address.latitude
		params[:lon] = Faker::Address.longitude
		params[:token] = user.token
		get(:update, params)
		assert_equal 1,Location.count
		location = Location.first
		assert_equal location.lon.to_f,params[:lon].to_f
		assert_equal 1,user.reload.influence
	end



end