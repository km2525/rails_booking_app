Rails.application.routes.draw do
  root "home#index"

  resources :users, only: [:new, :create, :edit, :update]
  resources :rooms, only: [:index, :new, :create]
  resources :schedules
  
  get    "/login",  to: "sessions#new",     as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout
end

