Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :messages, only: :index

  get '/rss_index' => 'rss#rss_index'
  get '/rss_show/:id' => 'rss#rss_show', as: 'rss_show'

  get '/atom_index' => 'rss#atom_index'
  get '/atom_show/:id' => 'rss#atom_show', as: 'atom_show'

  root 'messages#index'
end
