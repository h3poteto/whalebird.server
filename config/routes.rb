Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :omniauth_callbacks => "users/omniauth_callbacks"
  }

  resources :statics, only: :index

  namespace :users do
    resources :statics, only: :index
  end

  root to: "statics#index"
end
