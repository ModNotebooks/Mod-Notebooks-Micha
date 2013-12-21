Mod::Application.routes.draw do

  constraints subdomain: 'app' do
    # Login, signup, and settings are all handled through the API so ignore those controllers
    # the only things that happens outside of the API are confirming, unlocking,
    # and resetting passwords on accounts
    devise_for :users,
      skip: [:sessions, :registrations]

    # Routes handled by ember app
    root to: 'home#index'
    get '/login', to: 'home#index', as: :new_user_session
    get '/register', to: 'home#index', as: :new_user_registration

  end

  constraints subdomain: 'api', defaults: { format: 'json' } do

    use_doorkeeper do
      # The only thing allowed through the API oauth wise is requesting access tokens
      skip_controllers :applications, :authorized_applications, :authorizations
    end

    scope module: 'api/v1', constraints: ApiConstraints.new(version: 1, default: :true) do

      def user_resources
        resources :notebooks, only: [:index, :create, :show, :update] do
          resources :pages, only: [:index, :show]
        end
      end

      resources :notebooks, only: [:index, :create, :show, :update] do
        resources :pages, only: [:index, :show]
      end

      resources :users, only: [:show, :update, :create, :destroy] do
        user_resources
      end

      scope '/:user_id', constraints: { user_id: 'me' }, as: 'me' do
        user_resources
        get    '/', to: 'users#show'
        put    '/', to: 'users#update'
        patch  '/', to: 'users#update'
        delete '/', to: 'users#destroy'
      end

    end

  end

end
