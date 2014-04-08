Gridwebclient::Application.routes.draw do

	get 'users/login', to: 'users#login'
	get 'users/me', to: 'users#me'
	get 'users/active', to: 'users#active'
	get 'users', to: 'users#find'

end
