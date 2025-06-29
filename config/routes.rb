# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: "invitations", registrations: "registrations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#landing"

  get :home, to: "pages#home"

  get :accessibility, to: "pages#accessibility"

  get :inbox, to: "pages#inbox"

  resource :referrals, only: [:create]

  resources :registrations, only: [] do
    resource :avatar, only: [:update, :destroy]
  end

  get :faq, to: "pages#faq"

  resources :trips do
    member do
      get :export_pdf
    end
    resources :plans do
      member do
        get :new_backup_plan
      end
      resources :scannable_tickets, only: [:destroy]
      resources :documents, only: [:destroy]
    end
    resources :trip_memberships do
      member do
        post :accept_invite
        post :decline_invite
      end
    end
  end

  resources :subscriptions, only: [:new] do
    collection do
      get :pricing
    end
  end

  namespace :api do
    resources :avatars, only: [:show]

    resources :staff, only: [:update, :destroy]

    resources :registrations, only: [:create]

    resources :questions, only: [:create] do
      member do
        post :visibility
        post :answer
        post :click
        post :order
      end
    end

    resources :reviews, only: [:create] do
      member do
        post :visibility
        post :like
        post :order
      end
    end

    resources :features, only: [] do
      member do
        get :share
      end
    end

    resources :locations, only: [] do
      collection do
        get :search
      end
    end

    resources :users, only: [] do
      collection do
        get :search
      end
    end

    resources :featured_locations, only: [:show]

    get "/map/tile/:x/:y/:z", to: "map#tile", as: :map_tile
  end

  namespace :admin do
    get :dashboard, to: "dashboard#index"

    resources :staff, only: [:edit]

    resources :reviews, only: [] do
      collection do
        get :manage
      end
    end

    resources :registrations, only: [:show]

    resources :questions, only: [] do
      collection do
        get :manage
      end
    end
  end

  namespace :analytics do
    get :landing_page, to: "landing_page#index"
    resources :trips, only: [:index]
    resources :referrals, only: [:index]
  end
end
