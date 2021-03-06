Rails.application.routes.draw do
  root to: 'sessions#new'
  resources :sessions, only: [:new, :create, :destroy]
  resources :tasks
  resources :users, only: [:new, :create, :show]
  namespace :admin do
    resources :users
  end
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end
