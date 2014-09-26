require 'test_helper'

class FacebookTest < ActiveSupport::TestCase

	test "get_profile" do
		profile = Facebook.new(fbuser.token).get_profile
		assert profile["gender"] == "male" || profile["gender"] == "female"
	end

	test "exchange_token" do
		newtoken = Facebook.new(fbuser.token).exchange_token
		assert_instance_of String,newtoken
		assert_not_equal fbuser.token,newtoken
	end

	#test "verify_token works" do
	#	fb_hash
	#	assert Facebook.new(@@fbhash["access_token"]).verify_token?(@@fbprofile["id"])
	#	#assert_not Facebook.new.verify_token(user,"abc123")
	#end

	test "get_pics" do
		skip
		token = "CAAKUxhBDJwUBAIXqCkgi2ZBPKX8a18RZBfNbaZA8xovZAlfsVIZCIjqHZAOVaPLdYJfojgZBrNNjr4GSUibxFtn5Qily5qXR47P2MbZCoO8NeH0vqkTOWfMezOLEcjenTel6cJ2UFGg9iomJnwyk456zxDnvvsUevzQ2ZA6b1n2lhAZAk9oaBOJ0XJrrtftIUcil8ZD"
		assert_kind_of Hash,Facebook.new(token).get_pics
	end

end