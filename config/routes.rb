Gridwebclient::Application.routes.draw do

	get 'users/login', to: 'users#login'
	get 'users/me', to: 'users#me'
	get 'users/status', to: 'users#status'
	get 'users', to: 'users#find'
	get 'users/intro_map', to: 'users#intro_map'

	get 'locations/update', to: 'locations#update'

	get 'hunts/join', to: 'hunts#join'
	get 'hunts/success', to: 'hunts#success'
	get 'hunts/counteract', to: 'hunts#counteract'
	get 'hunts/intro_map', to: 'hunts#intro_map'
end
