Mod::Application.routes.draw do

  use_doorkeeper

  constraints subdomain: 'app' do
    # Login, signup, and settings are all handled through the API so ignore those controllers
    # the only things that happens outside of the API are confirming, unlocking,
    # and resetting passwords on accounts
    devise_for :users,
      skip: [:sessions, :registrations]

    scope module: 'app' do
      match 'auth/:provider/callback' , to: 'services#success', via: [:get, :post]
      match '/auth/failure'           , to: 'services#failure', via: [:get, :post]

      get '/login', to: 'base#index', as: :new_user_session
      get '/signup', to: 'base#index', as: :new_user_registration

      get '/styleguide', to: "base#guide"
      get '/layout', to: "base#layout"
      root to: 'base#index'

      get '*path',    to: 'base#index'
    end
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
      resources :services, only: [:index, :create, :show, :update, :destroy]
      resources :pages, only: [:index, :show]
      resources :users, only: [:create]
      resources :users, only: [:show, :update, :destroy], constraints: { id: 'me' }, as: 'me'
      resources :preferences, only: [:show, :update], constraints: { id: 'me' }, as: 'me'
      resources :addresses, only: [:show, :update], constraints: { id: 'me' }, as: 'me'

      post 'passwords/reset', to: 'passwords#reset'
    end

  end

end
