require 'sidekiq/web'
Rails.application.routes.draw do

  devise_for :admins
  devise_for :users, :controllers => {
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
        get :friends
        get :followers
        get :direct_messages
        post :tweet
        post :retweet
        post :favorite
        post :delete
        post :update_settings
      end
    end
  end

  root to: "statics#index"
end
