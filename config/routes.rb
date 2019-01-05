Rails.application.routes.draw do
  get 'movie_urls/index'
  get 'rooms/index'
  get 'playlists/index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root "rooms#index"
  
  resources :playlists
  resources :rooms
  resources :movie_urls
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
