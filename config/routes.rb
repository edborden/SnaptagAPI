Gridwebclient::Application.routes.draw do

	get 'users/login', to: 'users#login'
	get 'users/me', to: 'users#me'
	get 'users/status', to: 'users#status'
	get 'users', to: 'users#find'

	get 'hunts/join', to: 'hunts#join'
	get 'hunts/counteract', to: 'hunts#counteract'

	get 'locationrequest', to: 'locationrequest#locate'
end
