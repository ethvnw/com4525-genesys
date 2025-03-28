# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: "invitations", registrations: "registrations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#landing"

  get :home, to: "pages#home"

  resources :registrations, only: [] do
    resource :avatar, only: [:update, :destroy]
  end

  get :faq, to: "pages#faq"

  resources :trips do
    resources :plans
    resources :trip_memberships, only: [:index, :create, :destroy]
  end

  resources :subscriptions, only: [:new] do
    collection do
      get :pricing
    end
  end

  namespace :api do
    resources :staff, only: [:update, :destroy]

    resources :registrations, only: [:create]

    resources :trips, only: [:create]

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

  namespace :reporter do
    get :dashboard, to: "dashboard#index"
  end
end
