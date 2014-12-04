require File.expand_path('../boot', __FILE__)

require 'rails/all'


Bundler.require(*Rails.groups)

module Stalkers
	class Application < Rails::Application
		ActiveModel::Serializer.setup do |config|
			config.embed = :ids
			#config.embed_in_root = false
		end
		config.middleware.use "Cors"
		config.middleware.insert 0, "Cors"
	end
end
