Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'
  root "static_pages#home"
  get "static_pages/home"
  get "static_pages/help"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/users/:id/edit", to: "users#edit", as: "edit_user"
  get "/users", to: "users#index"
  patch "/users/:id", to: "users#update"
  resources :users
  resources :password_resets, only: %i(new create edit update)
  resources :account_activations, only: :edit

end
