source 'https://rubygems.org'

gem 'rails', '4.0.3'
gem 'rails-api'
gem 'active_model_serializers'
gem "koala", "~> 1.8.0rc1"

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