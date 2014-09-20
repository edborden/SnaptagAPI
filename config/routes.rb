Gridwebclient::Application.routes.draw do
	resources :sessions, only: [:show, :destroy]

	get 'users', to: 'users#find'

	get 'locations/update', to: 'locations#update'

	get 'hunts/join', to: 'hunts#join'
	get 'hunts/expose', to: 'hunts#expose'
	get 'hunts/counteract', to: 'hunts#counteract'
end
