Gridwebclient::Application.routes.draw do

	get 'users/login', to: 'users#login'
	get 'users/me', to: 'users#me'
	get 'users/status', to: 'users#user_status'
	get 'users', to: 'users#find'

	get 'locations/update', to: 'locations#update'
	get 'locations', to: 'locations#find'

	get 'hunts/join', to: 'hunts#join'
	get 'hunts/expose', to: 'hunts#expose'
	get 'hunts/counteract', to: 'hunts#counteract'
end
