Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Authentication
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Dashboard
  root "dashboard#index"

  # Work logs (punch in/out)
  resources :work_logs do
    collection do
      post :punch_in
    end
    member do
      get :punch_out
      post :complete_punch_out
      post :add_task
      get :new_task
    end
  end

  # Work Log Tasks (for task management during active sessions)
  resources :work_log_tasks, only: [] do
    member do
      post :start
      post :complete
    end
  end

  # Tasks
  resources :tasks do
    member do
      post :complete
    end
    collection do
      get :suggestions
      get :my_tasks
      get :search
    end
  end

  # Admin panel
  namespace :admin do
    root "dashboard#index"
    resources :users do
      resources :work_zones, only: [ :new, :create ]
    end
    resources :work_zones, only: [ :edit, :update, :destroy ]
    resources :tasks, only: [ :index, :show, :destroy ] do
      member do
        post :toggle_global
      end
    end
  end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
