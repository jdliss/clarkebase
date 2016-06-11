Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  get '/dashboard', to: 'dashboard#show'

  resources :wallets, only: [:show, :new, :create]

  namespace :api, default: { format: :json } do
    namespace :v1 do
      resource :wallets, only: [:create]
    end
  end

end
