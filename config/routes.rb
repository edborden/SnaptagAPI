Gridwebclient::Application.routes.draw do

	post 'users', to: 'users#create'
	get 'users/me', to: 'users#me'
	
end
