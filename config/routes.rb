Stacktician::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :stacks
  resources :create_stack

  root to: 'static_pages#home'

  match '/signup',  to: 'users#new'

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  match '/waitcondition/*handle_spec', to: 'stacks#wait_condition', :as => :waitcondition
  get '/metadata/:id/:name', to: 'api/stacks#resource_metadata'

  namespace :api, :defaults => {:format => :json} do
    resources :stacks do
      member do
        get :status
        get :resources
        get :events
        get :resource
        get :outputs
        get :parameters
      end
    end
    resources :templates
    
  end

end
