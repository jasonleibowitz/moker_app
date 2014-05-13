Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :coffee_shops, shallow: true do
    resource :foursquarereviews
    resource :reviews
    collection do
      get '/search', to: 'coffeeshops#search'
      get '/results', to: 'coffeeshops#results'
    end
  end
  resources :users
  root to: 'users#index'

end
