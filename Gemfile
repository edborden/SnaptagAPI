source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '4.1.6'
gem 'rails-api', "0.2.1"
gem 'active_model_serializers', git: "https://github.com/rails-api/active_model_serializers.git", ref: 'b9d216d'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
gem 'pg'
gem 'fabrication'
gem "faker"
gem "pusher"
gem "mailboxer"
gem "koala", "~> 1.10.0rc"

group :test do
	gem 'mocha', "~> 1.0.0"
end

group :production do
	gem 'rails_12factor'
	gem 'newrelic_rpm'
	gem 'unicorn', platforms: :ruby
end