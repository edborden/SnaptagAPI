Gridwebclient::Application.routes.draw do

	post 'users', to: 'users#create'
	get 'users/me', to: 'users#me'
	
	match '*path', to: 'application#cors_preflight_check', via: [:options]
end
