Rails.application.routes.draw do
  root 'dashboard#index'
  devise_for :users
  resources :customers, only: [ :index, :show ]
  get "angular_test", to: "angular_test#index"
end
