Rails.application.routes.draw do
  devise_for :users
  root "grams#index"
  resources :grams, only: [:new, :create, :show, :edit, :update, :destroy] do
    resources :comments, only: [:create, :destroy] do
      resources :responses, only: [:create, :destroy]
    end
  end
  resources :users, only: [:show]
end
