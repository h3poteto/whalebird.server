require 'sidekiq/web'
Rails.application.routes.draw do

  devise_for :admins
  devise_for :users, :controllers => {
    :registrations => "users/registrations",
    :sessions => "users/sessions",
    :omniauth_callbacks => "users/omniauth_callbacks"
  }

  authenticate :admin do
    mount Sidekiq::Web => 'admins/sidekiq'
  end

  resources :statics, only: :index

  namespace :users do
    resources :apis, only: :index do
      collection do
        get :home_timeline
        get :lists
        get :list_timeline
        get :mentions
        get :user
        get :profile_banner
        get :user_timeline
        get :user_favorites
        get :friends
        get :friend_screen_names
        get :followers
        get :direct_messages
        get :conversations
        get :search
        post :tweet
        post :upload
        post :retweet
        post :favorite
        post :unfavorite
        post :delete
        post :update_settings
        post :direct_message_create
        post :follow
        post :unfollow
        post :read
      end
    end
  end

  root to: "statics#index"
end
