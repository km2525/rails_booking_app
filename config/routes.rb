Rails.application.routes.draw do
  root "home#index"
  
  resources :users, only: [:new, :create, :edit, :update]

  resource :session, only: [:new, :create, :destroy]

  resources :rooms, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resources :reservations, only: [:create] do
      collection do
        get :confirm
      end
    end
    collection do
      get :my_rooms
    end
  end

  resources :reservations, only: [:index, :show, :destroy] do
    member do
      get :rebook  # 再予約ページ
    end
  end

  get '/settings', to: 'users#settings', as: :settings
  get '/settings/account', to: 'users#account', as: :account_settings
  patch '/settings/account', to: 'users#update_account'
  get '/settings/profile', to: 'users#profile', as: :profile_settings
  patch '/settings/profile', to: 'users#update_profile'

  get    "/login",  to: "sessions#new",     as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end