require 'sidekiq/web'

Rails.application.routes.draw do
  resources :drafts, only: [:index, :show, :edit, :update, :new, :create] do
    member do
      post :start
    end
  end
  resources :cubes, only: [:index, :show, :edit, :new, :create]
  resources :cube_cards, only: [:show, :edit, :update, :destroy]
  resources :draft_participants, only: [:new, :create, :edit, :update] do
    member do
      get :picks
    end
  end
  resources :surrogate_draft_participants, only: [:new, :create]
  resources :participant_picks, only: [:new, :create]
  resources :draft_chat_messages, only: [:create]
  devise_for :users, :controllers => { registrations: "users/registrations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/cable'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  get '/up', to: 'health#up'

  # Defines the root path route ("/")
  root to: "drafts#index"
end
