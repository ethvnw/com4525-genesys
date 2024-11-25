# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :reviews
  # POST: Update the like count for a review
  post "api/reviews/:id/likes", to: "reviews#update_like_count", as: :update_like_count

  # POST: Update the visibility of a review
  post "api/reviews/:id/visibility", to: "reviews#update_visibility", as: :update_visibility

  # POST: Update review order
  post "api/reviews/orders", to: "reviews#update_orders", as: :update_orders

  # Defines the root path route ("/")
  root "pages#home"

  # GET: Admin dashboard route
  get "admin/dashboard", to: "admin#dashboard", as: :admin_dashboard

  # GET: Admin review management route
  get "admin/manage_reviews", to: "admin#manage_reviews", as: :admin_manage_reviews

  # GET: Reporter dashboard route
  get "reporter/dashboard", to: "reporter#dashboard", as: :reporter_dashboard

  # POST: Sending a magic link route
  devise_scope :user do
    post "users/magic_link", to: "users/sessions#send_magic_link", as: :send_magic_link
  end
end
