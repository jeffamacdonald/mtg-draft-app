require 'sidekiq/web'

Rails.application.routes.draw do
  resources :cubes, only: [:index, :show, :edit, :new, :create]
  resources :cube_cards, only: [:show, :edit, :update, :destroy]
  resource :display_card do
    member do
      get :route
    end
  end
  resources :drafts, only: [:index, :show, :edit, :update, :new, :create] do
    member do
      post :start
      post :pick_list_size
    end
    resources :transfer_portal_transactions, only: [:index, :create]
  end
  resources :draft_chat_messages, only: [:create]
  resources :draft_participants, only: [:new, :create, :edit, :update] do
    member do
      get :picks
      get :pick_queue
    end
    resources :transfer_portal_transactions, only: [:new]
  end
  resources :participant_picks, only: [:new, :create, :update] do
    member do
      get :hovercard
    end
  end
  resources :queued_picks, only: [:new, :create, :destroy] do
    collection do
      patch :update_order
    end
  end
  resources :surrogate_draft_participants, only: [:new, :create]
  resources :transfer_portal_transactions do
    member do
      post :accept
      post :reject
      post :cancel
    end
  end
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
