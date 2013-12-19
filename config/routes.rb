Mod::Application.routes.draw do

  constraints subdomain: 'app' do
    authenticated :user do
      root :to => "home#index"
    end

    devise_for :users, skip: [:sessions, :registrations]
    devise_scope :user do
      get    "/login"    => "devise/sessions#new",         as: :new_user_session
      post   "/login"    => "devise/sessions#create",      as: :user_session
      delete "/logout"   => "devise/sessions#destroy",     as: :destroy_user_session
      get    "/register" => "devise/registrations#new",    as: :new_user_registration
      post   "/register" => "devise/registrations#create", as: :user_registration
    end
  end

  constraints subdomain: 'api', defaults: { format: :json } do
    scope module: 'api/v1', constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :notebooks, only: [:index, :create, :show, :update]
    end
  end

end
