Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  get '/dashboard', to: 'dashboard#show'

  resources :wallets, only: [:new, :create]

  resource :dashboard do
    collection do
      get '/wallets/:slug', to: 'wallets#show', as: "whallet"
    end
  end

  get '/transactions/new', to: 'transactions#new'

  get "/friends", to: "address_books#show", as: :friends

  namespace :api, default: { format: :json } do
    namespace :v1 do
      resource :transactions, only: [:create]
      resource :wallets, only: [:create]
      resource :address_books, only: [:update]
      resource :phones, only: [:update]
    end
  end

end
