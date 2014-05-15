require 'test_helper'

class LocationTest < ActiveSupport::TestCase

	test "create_from_client" do
		user = Fabricate(:user)
		params = {}
		params[:latitude] = Faker::Address.latitude
		params[:longitude] = Faker::Address.longitude
		params[:accuracy] = 40
		params[:timestamp] = 1236
		location = Location.create_from_client(user,params)
		assert_equal params[:accuracy],location.accuracy
	end


end
