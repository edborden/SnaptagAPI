require 'test_helper'

class FacebookTest < ActiveSupport::TestCase

	test "profile" do
		skip
		profile = Facebook.new(fbuser.token).profile
		assert profile["gender"] == "male" || profile["gender"] == "female"
	end

	test "exchange_token" do
		skip
		newtoken = Facebook.new(fbuser.token).exchange_token
		assert_instance_of String,newtoken
		assert_not_equal fbuser.token,newtoken
	end

	#test "verify_token works" do
	#	fb_hash
	#	assert Facebook.new(@@fbhash["access_token"]).verify_token?(@@fbprofile["id"])
	#	#assert_not Facebook.new.verify_token(user,"abc123")
	#end

end