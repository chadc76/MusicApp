Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: %i(show new create) do
    collection do
      get 'activate'
    end
  end

  resource :session, only: %i(new create destroy)

  resources :bands do
    resources :albums, only: [:new]
  end

  resources :albums, except: %i(new index) do
    resources :tracks, only: [:new]
  end

  resources :tracks, except: %i(new index)

  resource :notes, only: %i(create destroy)
  
  root to: 'sessions#new'
end
