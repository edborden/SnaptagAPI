require 'test_helper'

class FacebookTest < ActiveSupport::TestCase

	test "get_profile works" do
		user = fb_user
		profile = Facebook.new.get_profile(user.token)
		#test the above call returns data
		assert profile["gender"] == "male" || profile["gender"] == "female"
	end

	#test "exchange_token doesn't return the same token and get_profile works" do
	#	user = onetime_create_facebook_test_user
	#	oldtoken = user.token
	#	newtoken = Facebook.new.exchange_token(oldtoken)
	#	assert_instance_of String,newtoken
	#	assert_not_equal oldtoken,newtoken
	#end

	test "verify_token works" do
		fb_hash
		response = Koala::Facebook::API.new(FB_APP_ACCESS_TOKEN).debug_token(@@fbhash["access_token"])
		assert_not_nil response
		assert_equal response["data"]["user_id"],@@fbprofile["id"].to_i
		assert Facebook.new.verify_token?(@@fbprofile["id"],@@fbhash["access_token"])
		#assert_not Facebook.new.verify_token(user,"abc123")
	end

end