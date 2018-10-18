Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :messages, only: [:index, :show]

  get '/feed' => 'rss#rss_index'

  root 'messages#index'
end
