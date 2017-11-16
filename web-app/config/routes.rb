Rails.application.routes.draw do

	post '/messages/:id/done' => 'messages#done', as: 'messages_done'
	post '/messages/:id/hidden' => 'messages#hidden', as: 'messages_hidden'
	post '/messages/:id/not_relevant' => 'messages#not_relevant', as: 'messages_not_relevant'
	post '/messages/:id/actual' => 'messages#actual', as: 'messages_actual'
	root 'messages#index'


	TheRoleManagementPanel::Routes.mixin(self)
  # devise_for :users
  devise_for :users, :controllers => { :invitations => 'invitations' }
  resources :users
  resources :messages
  resources :categories

end

