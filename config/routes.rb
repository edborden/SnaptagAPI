Assassin::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  root "pages#home"
  #if Activationqueue.exists?
  #  post 'activationqueue', to: 'activationqueues#update'
  #else
  #  post 'activationqueue', to: 'activationqueues#create'
  #end
end
