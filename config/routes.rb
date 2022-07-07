Rails.application.routes.draw do
  # Root
  root "posts#index"

  # Users
  devise_for :users
  resources :users, only: [:index] do
    resources :notifications, only: [:index]
  end

  # Likes
  concern :likeable do
    resources :likes, shallow: true
  end

  # Posts
  resources :posts do
    resources :comments, shallow: true
    concerns :likeable
  end

  # Friend Requests
  resources :friend_requests, only: %i[show destroy]
  patch "friend_requests/:id/confirm_request",
        to: "friend_requests#confirm_request",
        as: "confirm_request"
end
