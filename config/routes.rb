Rails.application.routes.draw do

	resources :sessions, only: [:create, :show, :index, :destroy]
	resources :locations, only: :create
	resources :zones, only: :index
	resources :notifications, only: :update
	resources :activationqueues, only: :show
	resources :hunts, only: :show

	get 'actions/join', to: 'actions#join'
	get 'actions/found_target', to: 'actions#found_target'
	get 'actions/expose', to: 'actions#expose'
	get 'actions/unjoin', to: 'actions#unjoin'

	get 'versions', to: 'versions#index'

end
