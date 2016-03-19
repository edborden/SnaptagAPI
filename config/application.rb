require File.expand_path('../boot', __FILE__)

require 'rails/all'


Bundler.require(*Rails.groups)

module Snaptag
	class Application < Rails::Application
		ActiveModel::Serializer.setup do |config|
			config.embed = :ids
			#config.embed_in_root = false
		end

		config.middleware.insert_before 0, "Rack::Cors" do
			allow do
				origins '*'
				resource '*', :headers => :any, :methods => [:get, :post, :put, :patch, :options, :delete]
			end
    	end
	end
end
