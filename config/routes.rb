Rails.application.routes.draw do
  # root 'tasks#index'
  root to: 'sessions#new'
  resources :sessions, only: [:new, :create, :destroy]
  resources :tasks
  resources :users, only: [:new, :create, :show]
end
