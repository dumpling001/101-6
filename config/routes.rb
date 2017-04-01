Rails.application.routes.draw do
  devise_for :users
  resources :movies do
    member do
      post :join
      post :quit
    end
    resources :posts
  end

  namespace :account do
    resources :movies
    resources :posts
  end

  root 'movies#index'
end
