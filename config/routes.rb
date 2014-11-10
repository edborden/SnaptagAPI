Rails.application.routes.draw do
	resources :sessions, only: [:create, :index, :destroy]
	resources :locations, only: :create
	resources :zones, only: :index

	get 'hunts/join', to: 'hunts#join'
	get 'hunts/found_target', to: 'hunts#found_target'
	get 'hunts/expose', to: 'hunts#expose'
end
