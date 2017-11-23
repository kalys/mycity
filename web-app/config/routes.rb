Rails.application.routes.draw do
	root 'messages#index'

	TheRoleManagementPanel::Routes.mixin(self)
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
    collection do
      post ':id/destroy' => 'messages#archiving', as: 'archiving' 
    end
  	resources :images, only: [:create]
  end

end

