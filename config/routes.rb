Rails.application.routes.draw do
	resources :sessions, only: [:index, :destroy]
	resources :locations, only: :create
	resources :zones, only: :index

	get 'hunts/join', to: 'hunts#join'
	get 'hunts/expose', to: 'hunts#expose'
	get 'hunts/counteract', to: 'hunts#counteract'
end
