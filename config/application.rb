require File.expand_path('../boot', __FILE__)

require 'rails/all'


Bundler.require(:default, Rails.env)

module Gridwebclient
class Application < Rails::Application

I18n.config.enforce_available_locales = false

config.middleware.insert_before ActionDispatch::Static, Rack::Cors do 
    allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
    end
end

end
end
