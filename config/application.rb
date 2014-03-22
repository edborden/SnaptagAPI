require File.expand_path('../boot', __FILE__)

require 'rails/all'


Bundler.require(:default, Rails.env)

module Gridwebclient
	class Application < Rails::Application
		I18n.config.enforce_available_locales = false
		config.action_dispatch.default_headers = {
			'Access-Control-Allow-Origin' => '*',
			'Access-Control-Allow-Methods' => 'POST, PUT, PATCH, DELETE, GET, OPTIONS',
			'Access-Control-Request-Method' => '*',
			'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
		}
	end
end
