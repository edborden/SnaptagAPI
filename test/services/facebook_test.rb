require 'test_helper'

class FacebookTest < ActiveSupport::TestCase

	test "get_profile works" do
		user = fb_user
		profile = Facebook.new(user.token).get_profile
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
		assert Facebook.new(@@fbhash["access_token"]).verify_token?(@@fbprofile["id"])
		#assert_not Facebook.new.verify_token(user,"abc123")
	end

	

end