require File.expand_path('../boot', __FILE__)

require 'rails/all'


Bundler.require(:default, Rails.env)

module Gridwebclient
	class Application < Rails::Application
		I18n.config.enforce_available_locales = false
	end
end
