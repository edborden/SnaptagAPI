class Facebook

	def initialize(token)
		@token = token
	end

	def client
		@client ||= Koala::Facebook::API.new(@token)
	end

	def profile
		@profile ||= client.get_object("me")
	end

	#def verify_token?(facebookid)
	#	response = Koala::Facebook::API.new(FB_APP_ACCESS_TOKEN).debug_token(@token)
	#	return true if facebookid.to_i == response["data"]["user_id"]
	#end

	def profilepic
		@profilepic ||= client.get_object("me?fields=picture")
	end

	def smallpic
		@smallpic ||= profilepic["picture"]["data"]["url"]
	end

	def picId
		@picId ||= smallpic.split("_")[1]
	end

	def mediumpic
		puts request = "#{picId}?fields=picture"
		@mediumpic ||= client.get_object(request)["picture"]
	end

	def largepic
		@largepic ||= client.get_object("#{picId}?fields=source")["source"]
	end

	#def get_pic_id
	#end

	#def get_pic_album
	#end

	def oauth
		@oauth ||= Koala::Facebook::OAuth.new 726528350693125, "96ec2c1f6e53d6d1b4607164c190109c"
	end

	def exchange_token
		@token = oauth.exchange_access_token @token
	end

	def create_user
		User.create facebookid: profile["id"],
			name: profile["first_name"],
			email: profile["email"],
			gender: profile["gender"],
			#user.birthday = profile["birthday"]
			smallpic: smallpic,
			mediumpic: mediumpic,
			largepic: largepic
	end

end