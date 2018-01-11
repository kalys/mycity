Rails.application.routes.draw do
	root 'messages#index'
	TheRoleManagementPanel::Routes.mixin(self)
  devise_for :users, controllers: { invitations: 'invitations', sessions: 'sessions'}
  resources :users

  resources :categories, except: [:destroy] do
    collection do
      get :archived_categories, as: 'archived'
    end
    member do
      post :archiving
      post :unarchiving
    end
  end

  resources :messages do
    collection do
      post ':id/destroy' => 'messages#archiving', as: 'archiving'
    end
    resources :images, only: [:create]
  end
  post '/messages/:message_id/image' => 'messages#image_save'

  get '/rss' => 'rss#rss'
  get '/atom' => 'rss#atom'
end
