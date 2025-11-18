Rails.application.routes.draw do
  root "posts#index"

  devise_for :users
  resources :posts do
    resources :comments, only: [:new, :create]
  end

  resources :conversations, only: [:index, :show, :new, :create] do
    resources :messages, only: [:create]
  end

  get "dashboard", to: "posts#dashboard"
end
