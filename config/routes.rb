# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: "invitations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "pages#home"

  get :faq, to: "pages#faq"

  resources :subscriptions, only: [:index, :new]

  namespace :api do
    resources :staff, only: [:update, :destroy]

    resources :registrations, only: [:create]

    resources :questions, only: [:create] do
      member do
        post :visibility
        post :answer
      end

      collection do
        post :update_orders
      end
    end

    resources :reviews, only: [:create] do
      member do
        post :visibility
        post :like
      end

      collection do
        post :update_orders
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
