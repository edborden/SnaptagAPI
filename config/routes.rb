Gridwebclient::Application.routes.draw do

	post 'users', to: 'users#create'
	get 'users/me', to: 'users#me'

	match "*all" => "application#cors_preflight_check", :constraints => { :method => "OPTIONS" }
end
