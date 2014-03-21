Gridwebclient::Application.routes.draw do
	post 'users', to: 'users#create'
	get 'users', to: 'users#show'
end
