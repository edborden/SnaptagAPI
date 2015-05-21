class GoogleCloudHandler

	def initialize reg_id
		@key = "AIzaSyCuNmd-up-Bus9PgQ1Q3xwdKMT4drRWppM"
		@reg_id = reg_id
	end

	def client
		@client ||= GCM.new @key
	end

	def send_message subject="-", body="-"
		options = {data: {message: body,title:subject}, collapse_key: "update"}
		client.send([@reg_id], options)
	end

end