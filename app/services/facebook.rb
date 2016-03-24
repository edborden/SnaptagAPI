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

	def facebookid
		@facebookid ||= profile["id"]
	end

	#def verify_token?(facebookid)
	#	response = Koala::Facebook::API.new(FB_APP_ACCESS_TOKEN).debug_token(@token)
	#	return true if facebookid.to_i == response["data"]["user_id"]
	#end

	def smallpic
		HTTParty.get("http://graph.facebook.com/#{facebookid}/picture?type=normal&redirect=false")["data"]["url"]
	end

	def largepic
		HTTParty.get("http://graph.facebook.com/#{facebookid}/picture?type=large&redirect=false")["data"]["url"]
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
		user = User.create facebookid: facebookid,
			name: profile["first_name"],
			email: profile["email"],
			gender: profile["gender"],
			#user.birthday = profile["birthday"]
			smallpic: smallpic,
			largepic: largepic
		json_package = MeSerializer.new user
		Keen.publish 'signup', json_package
		return user
	end

end