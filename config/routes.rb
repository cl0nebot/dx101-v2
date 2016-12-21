Rails.application.routes.draw do

  get 'profiles/new'

  get 'profiles/create'

  get 'profiles/update'

  get 'profiles/edit'

  get 'profiles/show'

  resources :binary_orders, path: :options
  #, only: [:index, :show, :edit, :update, :history]

  resources :binary_rounds

  require 'sidekiq/web'
  require 'sidetiq/web'

authenticate :user, lambda { |u| u.admin? } do
#  mount Sidekiq::Web => '/sidekiq'

# work in progress stuff hidden from all but admin
  resources :loans
  resources :trades
end

  mount Sidekiq::Web => '/sidekiq'

  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/transactions'
  get 'dashboard/deposit'
  get 'dashboard/withdraw'
  get 'dashboard/btcdepaddress'  
  get 'dashboard/accept_tos'
  post 'dashboard/wdreq'
  post 'dashboard/tosupdate'

  namespace :dashboard do
    resources :crypto_addresses
    resources :aff_codes
    resources :reports
  end

  post '2zj1a61N1Mya3hn', to: 'listener#deposit'
 
  devise_for :users, controllers: {registrations: 'users/registrations', sessions: 'users/sessions'}
  resources :profiles
  #devise_for :users
  #resources :users

# CMSable Stuff
  resources :pages
  resources :buy_bitcoins
  resources :homepage
  get 'leaderboard', to: 'homepage#leaderboard'
  get 'leaderboard/:id', to: 'homepage#pools', as: "pooldetail"
  root to: 'homepage#index'

end
