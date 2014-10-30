Rails.application.routes.draw do

  resources :statics, only: :index
  root to: "statics#index"
end
