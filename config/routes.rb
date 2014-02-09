Assassin::Application.routes.draw do
	root "pages#home"
  #if Activationqueue.exists?
  #  put 'activationqueue', to: 'activationqueues#update'
  #else
  #  post 'activationqueue', to: 'activationqueues#create'
  #end
	delete 'sessions', to: 'sessions#destroy', as: 'signout'
	post 'sessions', to: 'sessions#create', as: 'login'
	get 'users', to: 'users#show'
	get 'user/:firstname', to: 'users#test'
end
