require "resque_web"

Mod::Application.routes.draw do

  #-----------------------------------------------------------------------------
  # Callbacks / Webhooks
  #-----------------------------------------------------------------------------

  constraints subdomain: 'callback' do
    scope module: 'blitline' do
      post '/notebooks/:id/blitline', to: 'notebooks#blitline', as: :notebook_processed
    end
  end

  #-----------------------------------------------------------------------------
  # Client Application
  #-----------------------------------------------------------------------------

  constraints subdomain: 'app' do
    use_doorkeeper

    # Login, signup, and settings are all handled through the API so ignore those controllers
    # the only things that happens outside of the API are confirming, unlocking,
    # and resetting passwords on accounts
    devise_for :users,
      skip: [:sessions, :registrations]

    # Resque Web Interface
    # https://github.com/resque/resque-web/issues/29
    ResqueWeb::Engine.eager_load!
    mount ResqueWeb::Engine => "/resque_web"

    scope module: 'app' do
      match 'auth/:provider/callback', to: 'services#success', via: [:get, :post]
      match '/auth/failure', to: 'services#failure', via: [:get, :post]

      get '/login', to: 'home#index', as: :new_user_session
      get '/signup', to: 'home#index', as: :new_user_registration
      get '/password_reset', to:'home#index'
      get '/demo', to:'home#index'
      get '/notebooks', to: 'home#index'
      get '/notebooks/:id', to: 'home#index'
      get '/notebooks/:id/view/:left_page_number/:right_page_number', to: 'home#index'
      get '/notebooks/:id/touchview', to: 'home#index'
      get '/notebooks/:id/touchview/:index', to: 'home#index'
      get '/digitize', to: 'home#index'
      get '/digitize/code', to: 'home#index'
      get '/digitize/scan', to: 'home#index'
      get '/digitize/address', to: 'home#index'
      get '/digitize/confirmation', to: 'home#index'

      get '/styleguide', to: "home#guide"
      get '/layout', to: "home#layout"

      root to: 'home#index'
    end
  end

  #-----------------------------------------------------------------------------
  # API
  #-----------------------------------------------------------------------------

  constraints subdomain: 'api', defaults: { format: 'json' } do
    use_doorkeeper do
      # The only thing allowed through the API oauth wise is requesting access tokens
      skip_controllers :applications, :authorized_applications, :authorizations
    end

    scope module: 'api/v1', constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :shares, param: :token, only: [:create, :show, :destroy]
      resources :notebooks, only: [:index, :create, :show, :update] do
        post 'exists', on: :collection
      end
      resources :services, only: [:index, :create, :show, :update, :destroy]
      resources :pages, only: [:index, :show]
      resources :users, only: [:create]
      resources :users, only: [:show, :update, :destroy], constraints: { id: 'me' }, as: 'me'
      resources :preferences, only: [:show, :update], constraints: { id: 'me' }, as: 'me'
      resources :addresses, only: [:show, :update], constraints: { id: 'me' }, as: 'me'
    end
  end

  #-----------------------------------------------------------------------------
  # Partner Section
  #-----------------------------------------------------------------------------

  constraints subdomain: 'partners' do
    scope module: 'partner' do
      resources :notebooks, only: [:index, :update]
      
      get '/', to: 'notebooks#index'
    end
  end

end
