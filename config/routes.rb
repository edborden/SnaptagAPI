Rails.application.routes.draw do
	resources :sessions, only: [:show, :destroy]
	resources :locations, only: :create
	resources :users, only: :index

	get 'hunts/join', to: 'hunts#join'
	get 'hunts/expose', to: 'hunts#expose'
	get 'hunts/counteract', to: 'hunts#counteract'
end
