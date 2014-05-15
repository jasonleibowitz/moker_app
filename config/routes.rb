Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get '/about' => 'welcome#about'
  resources :coffee_shops, shallow: true do
    resource :foursquarereviews
    resource :reviews
    resources :tips
    collection do
      get '/search', to: 'coffee_shops#search'
      get '/results', to: 'coffee_shops#results'
      post ':id/checkin' => 'users#check_in', :as => 'check_in'
    end
  end
  resources :users
  root to: 'coffee_shops#index'

end
