class Cors
	def initialize(app)
		@app = app
	end

	def call(env)
		status, headers, response = @app.call(env)

		headers['Access-Control-Allow-Origin'] = '*'
		headers['Access-Control-Allow-Methods'] = 'POST, GET, DELETE, PUT, PATCH'
		headers['Access-Control-Max-Age'] = '1728000'

		[status, headers, response]
	end
end