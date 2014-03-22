Gridwebclient::Application.routes.draw do
	#constraints :format => "json" do
		post 'users', to: 'users#create', :constraints => { :format => 'json' } 
		get 'users', to: 'users#show'
	#end
end
