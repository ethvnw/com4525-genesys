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

  resources :questions

  # POST: Update the like count for a question
  post "api/questions/:id/likes", to: "questions#update_like_count", as: :update_question_like_count

  # POST: Update the visibility of a question
  post "api/questions/:id/visibility", to: "questions#update_visibility", as: :update_question_visibility

  # POST: Update question order
  post "api/questions/orders", to: "questions#update_orders", as: :update_question_orders

  # POST: Answer a question
  post "questions/:id/answer", to: "questions#answer", as: :answer_question

  # Defines the root path route ("/")
  root "pages#home"

  # GET: FAQ route
  get "faq", to: "pages#faq", as: :faq

  # GET: Admin dashboard route
  get "admin/dashboard", to: "admin#dashboard", as: :admin_dashboard

  # GET: Admin review management route
  get "admin/manage_reviews", to: "admin#manage_reviews", as: :admin_manage_reviews

  # GET: Admin question management route
  get "admin/manage_questions", to: "admin#manage_questions", as: :admin_manage_questions

  # GET: Reporter dashboard route
  get "reporter/dashboard", to: "reporter#dashboard", as: :reporter_dashboard

  # POST: Sending a magic link route
  devise_scope :user do
    post "api/users/magic_link", to: "magic_password#send_magic_link", as: :send_magic_link
  end

  # GET: User avatar route
  get "api/users/avatar", to: "avatar#show", as: :user_avatar

  # GET / PATCH / DELETE: Admin routes for handling staff accounts
  get "staff/:id/edit", to: "admin#edit_staff", as: :edit_staff
  patch "api/staff/:id", to: "admin#update_staff", as: :update_staff
  delete "api/staff/:id", to: "admin#destroy_staff", as: :destroy_staff
end
