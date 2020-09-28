Rails.application.routes.draw do
  apipie
  mount_devise_token_auth_for 'User', at: 'auth'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :projects do
        resources :tasks do
          member { patch :position }
          member { patch :complete }
          member { patch :deadline }
        end
      end
    end
  end
end
