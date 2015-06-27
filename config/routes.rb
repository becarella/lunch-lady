Rails.application.routes.draw do
  match ':any', :constraints => {:any => /.*/}, :via => 'options', :to => "application#cors_preflight_check"

  resources :orders, only: [:index, :show] do
    member do
      post '/charge' => 'orders#charge'
    end
  end

  resources :line_items, only: [:update]

  resources :users, only: [:show, :update]
  get '/users/me' => 'users#show', as: :me

  get '/venmo/authorize'  => 'venmo#authorize'
  get '/venmo/callback'  => 'venmo#callback', as: :venmo_callback
end
