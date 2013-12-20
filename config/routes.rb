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

  constraints subdomain: 'api', defaults: { format: :json } do

    use_doorkeeper do
      # The only thing allowed through the API oauth wise is requesting access tokens
      skip_controllers :applications, :authorized_applications, :authorizations
    end

    scope module: 'api/v1', constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :notebooks, only: [:index, :create, :show, :update] do
        resources :pages, only: [:index]
      end

      resources :pages, only: [:show]
      resources :users, only: [:show, :update, :create, :destroy]
    end
  end

end
