Rails.application.routes.draw do
	resources :sessions, only: [:create, :index, :destroy]
	resources :locations, only: :create
	resources :zones, only: :index
	resources :notifications, only: :update

	get 'hunts/join', to: 'hunts#join'
	get 'hunts/found_target', to: 'hunts#found_target'
	get 'hunts/expose', to: 'hunts#expose'

	match "*all" => "application#cors_preflight_check", via: [:options]

end
