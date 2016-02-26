source 'https://rubygems.org'
ruby '2.2.3'

gem 'rails', '4.1.9'
gem 'rails-api', "0.4.0"
gem 'active_model_serializers', git: "https://github.com/rails-api/active_model_serializers.git", ref: 'b9d216d'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
gem 'pg'
gem 'fabrication', '2.13.2'
gem "faker", '1.4.3'
gem "pusher", '0.14.5'
gem "mailboxer", '0.12.5'
gem "koala", "~> 1.10.0rc"
gem 'rack-cors', '0.4.0', require: 'rack/cors'
gem 'gcm', '0.1.0', require: 'gcm'
gem 'httparty', '0.13.4'

group :test do
	gem 'mocha', "~> 1.0.0"
end

group :production do
	gem 'rails_12factor'
	gem 'newrelic_rpm'
	gem 'unicorn', platforms: :ruby
end