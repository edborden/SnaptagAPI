Gridwebclient::Application.routes.draw do

	get 'users/login', to: 'users#login'
	get 'users', to: 'users#find'

end
