Gridwebclient::Application.routes.draw do

	get 'users/login', to: 'users#login'
	get 'users/me', to: 'users#me'
	get 'users/web', to: 'users#web'

end
