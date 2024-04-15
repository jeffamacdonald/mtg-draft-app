Rails.application.routes.draw do
  resources :drafts, only: [:index, :show, :edit, :update, :new, :create]
  resources :cubes, only: [:index, :show, :edit, :new, :create]
  resources :cube_cards, only: [:edit, :update]
  resources :draft_participants, only: [:new, :create]
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "drafts#index"
end
