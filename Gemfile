source 'https://rubygems.org'

gem 'rails', '4.0.3'
gem 'rails-api'
gem 'bcrypt-ruby', '~> 3.1.2'
gem 'active_model_serializers'

group :development, :test do
     gem 'sqlite3'
end

group :test do
	gem 'fabrication'
	gem "faker", "~> 1.2.0"
	gem 'mocha'
end

group :production do
     gem 'pg'
     gem 'rails_12factor'
end