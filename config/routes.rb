Rails.application.routes.draw do
  # devise_for :users
  devise_for :users, defaults: { format: :html }

  namespace :api do
    devise_for :users, defaults: { format: :json },
                      class_name: 'User',
                      controllers: {
                        sessions: 'api/sessions',
                        registrations: 'api/registrations'
                      }
    devise_scope :user do
      post '/users/sign_in' => 'sessions#create'
      get '/users/sign_in' => 'devise/sessions#new'
      delete '/users/sign_out' => 'devise/sessions#destroy'
      post '/users/sign_up' => 'registrations#create'
    end
  end

  # get 'welcome/index'
  # post 'welcome/index', to: 'welcome#new'
  # root "welcome#index"
  root 'tasks#index'

  resources :tasks
  match '*path' => redirect('tasks#index'), via: :get
end
