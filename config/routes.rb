Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: %i(show new create index) do
    collection do
      get 'activate'
    end
    member do 
      get 'remove_admin'
      get 'make_admin'
    end
  end

  resource :session, only: %i(new create destroy)

  resources :bands do
    resources :albums, only: [:new]
    member do
      get 'new_tag'
      get 'edit_tags'
      post 'tag'
      delete 'untag'
    end
  end

  resources :albums, except: %i(new index) do
    resources :tracks, only: [:new]
    member do
      get 'new_tag'
      get 'edit_tags'
      post 'tag'
      delete 'untag'
    end
  end

  resources :tracks, except: %i(new index) do
    member do
      get 'new_tag'
      get 'edit_tags'
      post 'tag'
      delete 'untag'
    end
  end

  resources :notes, only: %i(create destroy)

  resource :search_results, only: %i(show)
  
  root to: 'sessions#new'
end
