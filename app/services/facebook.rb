class Facebook

	def get_profile(token)
		Koala::Facebook::API.new(token).get_object("me")
	end

	def exchange_token(token)
		oauth ||= Koala::Facebook::OAuth.new(726528350693125, "96ec2c1f6e53d6d1b4607164c190109c")
		oauth.exchange_access_token(token)
	end

	def facebook
		@facebook ||= Koala::Facebook::API.new(token)
	end

end