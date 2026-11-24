Rails.application.routes.draw do
  root "home#index"

  get  "/register", to: "registrations#new",    as: :register
  post "/register", to: "registrations#create"

  get    "/login",  to: "sessions#new",         as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy",     as: :logout

  resources :notes, only: [ :index, :new, :create, :destroy, :edit, :update ] do
    member do
      patch :share
      patch :revoke
    end
  end

  resources :habits, only: [ :index, :new, :create, :destroy ]

  get "s/:token", to: "public_notes#show", as: :public_note
  patch "s/:token", to: "public_notes#update"
end
