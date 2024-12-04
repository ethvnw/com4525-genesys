# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: "invitations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :staff, only: [:update, :destroy]

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

  # Defines the root path route ("/")
  root "pages#home"

  # GET: FAQ route
  get "faq", to: "pages#faq", as: :faq

  # GET: Reporter dashboard route
  get "reporter/dashboard", to: "reporter#dashboard", as: :reporter_dashboard

  # GET: User avatar route
  get "api/users/avatar", to: "avatar#show", as: :user_avatar

  # GET: Subscription tiers pricing route
  get "subscriptions/pricing", to: "subscription_tiers#pricing", as: :subscription_tiers_pricing

  # GET: Subscription tiers register route
  get "subscriptions/register", to: "subscription_tiers#register", as: :subscription_tiers_register

  post "api/registrations", to: "registrations#create", as: :registrations
end
