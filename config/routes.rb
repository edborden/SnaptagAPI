Assassin::Application.routes.draw do
  root "pages#home"
  #if Activationqueue.exists?
  #  put 'activationqueue', to: 'activationqueues#update'
  #else
  #  post 'activationqueue', to: 'activationqueues#create'
  #end
  	get 'sessions', to: 'sessions#destroy', as: 'signout'
  	get 'auth/:provider/callback', to: 'sessions#create'
	get 'auth/failure', to: redirect('/')
end
