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
  resources :categories, except: [:destroy] do 
    collection do 
      post ':id/archiving' => 'categories#archiving', as: 'archiving'
      post ':id/unarchiving' => 'categories#unarchiving', as: 'unarchiving'
      get '/archived' => 'categories#show_archived_categories', as: 'archived'
    end
  end

  resources :messages do 
  	resources :images, only: [:create]
  end

end

