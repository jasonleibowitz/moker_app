Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :coffeeshops, shallow: true do
    resource :foursquarereviews
    resource :reviews
  end
  resources :users
  root to: 'users#index'
end
