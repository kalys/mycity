Rails.application.routes.draw do

	root 'users#index'
	TheRoleManagementPanel::Routes.mixin(self)
  devise_for :users
  resources :users
  resources :messages
  resources :categories
end
