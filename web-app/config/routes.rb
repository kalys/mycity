Rails.application.routes.draw do

	root 'messages#index'
	TheRoleManagementPanel::Routes.mixin(self)
  # devise_for :users
  devise_for :users, :controllers => { :invitations => 'invitations' }
  resources :users
  resources :messages
  resources :categories
end
