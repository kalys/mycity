Rails.application.routes.draw do
  root 'messages#index'
  TheRoleManagementPanel::Routes.mixin(self)
  devise_for :users, except: :new, controllers: { invitations: 'invitations', sessions: 'sessions'}
  resources :users, only: [:index, :destroy]

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

  get '/rss_index' => 'rss#rss_index'
  get '/rss_show/:id' => 'rss#rss_show', as: 'rss_show'

  get '/atom_index' => 'rss#atom_index'
  get '/atom_show/:id' => 'rss#atom_show', as: 'atom_show'
end
