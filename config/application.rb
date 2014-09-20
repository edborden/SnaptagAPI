require File.expand_path('../boot', __FILE__)

require 'rails/all'


Bundler.require(:default, Rails.env)

module Gridwebclient
	class Application < Rails::Application
		ActiveModel::Serializer.setup do |config|
			config.embed = :ids
			config.embed_in_root = false
		end
	end
end
