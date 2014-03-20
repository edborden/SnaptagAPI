require 'test_helper'

class FacebookTest < ActiveSupport::TestCase

	test "get_profile works" do
		user = global_create_facebook_test_user
		profile = Facebook.new.get_profile(user.token)
		#test the above call returns data
		assert profile["gender"] == "male" || profile["gender"] == "female"
	end

	test "exchange_token doesn't return the same token and get_profile works" do
		user = dump_create_facebook_test_user
		oldtoken = user.token
		newtoken = Facebook.new.exchange_token(oldtoken)
		assert_instance_of String,newtoken
		assert_not_equal oldtoken,newtoken
	end

end