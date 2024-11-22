# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :reviews
  # Defines the root path route ("/")
  root "pages#home"

  # GET: Admin dashboard route
  get "admin/dashboard", to: "admin#dashboard", as: :admin_dashboard

  # GET: Reporter dashboard route
  get "reporter/dashboard", to: "reporter#dashboard", as: :reporter_dashboard
end
