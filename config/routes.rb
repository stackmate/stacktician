class CFNConstraint
  def initialize
    @aws = true
  end

  def matches?(request)
    request.query_string.include?("DescribeStackResource")
  end
end

Stacktician::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :stacks
  resources :create_stack

 

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
  get '/', to: 'api/stacks#resource_metadata_cfn', constraints: CFNConstraint.new
  root to: 'static_pages#home'
end
