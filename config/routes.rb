Rails.application.routes.draw do
  root 'posts#index'
  
  # Authentication routes
  get 'register', to: 'users#new'
  post 'register', to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  # Two-factor authentication
  get 'two_factor', to: 'sessions#two_factor'
  post 'two_factor', to: 'sessions#verify_two_factor'
  get 'two_factor_setup', to: 'users#two_factor_setup'
  post 'enable_two_factor', to: 'users#enable_two_factor'
  
  # User routes
  resources :users, only: [:show, :edit, :update]
  
  # Post routes
  resources :posts do
    member do
      get 'edit'
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
