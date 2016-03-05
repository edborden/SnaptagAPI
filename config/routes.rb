Rails.application.routes.draw do

	resources :sessions, only: [:create, :show, :index, :destroy]
	resources :locations, only: :create
	resources :zones, only: :index
	resources :notifications, only: :update
	resources :activationqueues, only: :show

	get 'hunts/join', to: 'hunts#join'
	get 'hunts/found_target', to: 'hunts#found_target'
	get 'hunts/expose', to: 'hunts#expose'
	get 'hunts/unjoin', to: 'hunts#unjoin'

	get 'versions', to: 'versions#index'

end
