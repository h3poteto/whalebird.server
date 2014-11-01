Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks"
  }

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
        post :tweet
        post :retweet
        post :favorite
        post :delete
      end
    end
  end

  root to: "statics#index"
end
