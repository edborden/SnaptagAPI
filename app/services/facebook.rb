class Facebook

	def initialize(token)
		@token = token
		@facebook ||= Koala::Facebook::API.new(@token)
	end

	def get_profile
		@facebook.get_object("me")
	end

	def verify_token?(facebookid)
		response = Koala::Facebook::API.new(FB_APP_ACCESS_TOKEN).debug_token(@token)
		return true if facebookid.to_i == response["data"]["user_id"]
	end

	def get_pics
		get_picId_profile
		get_medium_pic
		get_large_pic
		pichash = {smallpic: @smallpic,mediumpic: @mediumpic,largepic: @largepic}
	end

	def get_picId_profile
		result = @facebook.get_object("me?fields=picture")
		@smallpic = picId["picture"]["data"]["url"]
		picId = @smallpic.split("_")
		@picId = picId[1]
	end

	def get_medium_pic
		string = @picId + "?fields=picture"
		hash = @facebook.get_object(string)
		@mediumpic = hash["picture"]
	end

	def get_large_pic
		call = @picId + "?fields=source"
		hash = @facebook.get_object(call)
		@largepic = hash["source"]
	end

	#def get_pic_id
	#end

	#def get_pic_album
	#end

	#def exchange_token(token)
	#	oauth ||= Koala::Facebook::OAuth.new(726528350693125, "96ec2c1f6e53d6d1b4607164c190109c")
	#	oauth.exchange_access_token(token)
	#   Koala::Facebook::API.new("726528350693125|Cu3OUIvH7s7j6s1wuJFo1SQOpSk").debug_token()
	#end


	#Koala::Facebook::API.new("CAAKUxhBDJwUBABFISPBeCyuvh2fR2cqHgyDyCnIe3tHJ9JmYENbEz1uxvLSB6HZAf2TIQoO9hmc4kSt1MnwLTZC2JGhwhAekDDZA8nZAQS8NlfQ8Qh4BWzsisWtBVrs2Delp7i9TNZBp2rBVL9J1qZBb8uehQZAKnvihkSZCLTmYWEdUVne7ssZCqX7tsCZAL9fCkZD").get_object("me/albums?fields=type")
	# me/albums?fields=type
end