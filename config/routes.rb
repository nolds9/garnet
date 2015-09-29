Rails.application.routes.draw do
  root to: 'application#welcome'

  get '/sign_in', to: 'users#sign_in'
  post '/sign_in', to: 'users#sign_in!'
  get '/sign_up', to: 'users#sign_up'
  post '/sign_up', to: 'users#sign_up!'
  get '/sign_out', to: 'users#sign_out'

  # students submissions end-point
  get 'memberships/:id/submissions', to: "submissions_api#index"

  get "github/authorize", to: "users#gh_authorize"
  get "github/authenticate", to: "users#gh_authenticate"

  resources :groups

end
