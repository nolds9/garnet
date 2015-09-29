Rails.application.routes.draw do
  root to: 'application#welcome'

  get '/sign_in', to: 'users#sign_in'
  post '/sign_in', to: 'users#sign_in!'
  get '/sign_up', to: 'users#sign_up'
  post '/sign_up', to: 'users#sign_up!'
  get '/sign_out', to: 'users#sign_out'

  # students submissions end-point
  get 'api/memberships/:id/submissions', to: "submissions_api#index"

  # groups api routes
  get 'api/groups', to: "groups_api#index"
  get 'api/groups/:id', to: "groups_api#students"
  get 'api/groups/:id/attendance_summary', to: "groups_api#students_attendances"
  get 'api/groups/:id/submission_summary', to: "groups_api#students_submissions"

  get "github/authorize", to: "users#gh_authorize"
  get "github/authenticate", to: "users#gh_authenticate"

  resources :groups

end
