Gridwebclient::Application.routes.draw do
	#constraints :format => "json" do
		post 'users', to: 'users#create', format: false
		get 'users', to: 'users#show'
	#end
end
