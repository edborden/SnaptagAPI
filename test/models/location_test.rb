require 'test_helper'

class LocationTest < ActiveSupport::TestCase

	test "create_from_client" do
		user = Fabricate(:user)
		params = {}
		params[:lat] = Faker::Address.latitude
		params[:lon] = Faker::Address.longitude
		location = Location.create_from_client(user,params)
		assert_equal params[:lat].to_f,location.lat.to_f
	end


end
