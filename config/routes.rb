Rails.application.routes.draw do
  resources :drafts, only: [:index, :show, :edit, :new, :create]
  resources :cubes, only: [:index, :show, :edit, :new, :create]
  devise_for :users
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "home#index"
end
