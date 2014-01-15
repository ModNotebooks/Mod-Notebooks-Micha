Mod::Application.routes.draw do

  use_doorkeeper


  constraints subdomain: 'app' do
    # Login, signup, and settings are all handled through the API so ignore those controllers
    # the only things that happens outside of the API are confirming, unlocking,
    # and resetting passwords on accounts
    devise_for :users,
      skip: [:sessions, :registrations]

    get '/login',    to: 'home#index', as: :new_user_session
    get '/signup',    to: 'home#index', as: :new_user
    get '/register', to: 'home#index', as: :new_user_registration
    get '/s/:token', to: 'home#index', as: :share

    get '/styleguide', to: "home#guide"
    get '/layout', to: "home#layout"
    root to: 'home#index'
  end

  constraints subdomain: 'api', defaults: { format: 'json' } do

    use_doorkeeper do
      # The only thing allowed through the API oauth wise is requesting access tokens
      skip_controllers :applications, :authorized_applications, :authorizations
    end

    scope module: 'api/v1', constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :shares, param: :token, only: [:create, :show, :destroy]
      resources :notebooks, only: [:index, :create, :show, :update] do
        post 'upload', on: :collection
      end
      resources :pages, only: [:index, :show]
      resources :users, only: [:show, :update, :create, :destroy]
    end

  end

end
