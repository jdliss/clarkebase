Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  get '/wallets/new', to: 'wallets#new'
  get '/dashboard', to: 'dashboard#show'

  namespace :api, default: { format: :json } do
    namespace :v1 do
      resource :wallets, only: [:create]
    end
  end

end
