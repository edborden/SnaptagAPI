class Facebook

	def get_profile(token)
		Koala::Facebook::API.new(token).get_object("me")
	end

	def verify_token?(facebookid,token)
		response = Koala::Facebook::API.new(FB_APP_ACCESS_TOKEN).debug_token(token)
		return true if facebookid.to_i == response["data"]["user_id"]
	end

	#def exchange_token(token)
	#	oauth ||= Koala::Facebook::OAuth.new(726528350693125, "96ec2c1f6e53d6d1b4607164c190109c")
	#	oauth.exchange_access_token(token)
	#   Koala::Facebook::API.new("726528350693125|Cu3OUIvH7s7j6s1wuJFo1SQOpSk").debug_token()
	#end

	#def facebook
	#	@facebook ||= Koala::Facebook::API.new(token)
	#end

end