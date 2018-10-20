# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :messages, only: %i[index show]

  get '/feed' => 'rss#rss_index'

  root 'messages#index'
end
