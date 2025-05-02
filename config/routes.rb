# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :messages, only: [:create, :index]
    end
  end
  get "up", to: "rails/health#show", as: :rails_health_check

  devise_for :users,
    path: "",
    skip: [:sessions, :registrations],
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }

  as :user do
    post "login", to: "users/sessions#create", as: :user_session
    delete "logout", to: "users/sessions#destroy", as: :destroy_user_session
    post "signup", to: "users/registrations#create", as: :user_registration
  end
end
