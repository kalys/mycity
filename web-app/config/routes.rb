Rails.application.routes.draw do
  get 'users/new'

  get 'users/edit'

  get 'users/index'

  devise_for :users
  root 'users#index'
end
