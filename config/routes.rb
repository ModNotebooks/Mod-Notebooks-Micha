Mod::Application.routes.draw do

  constraints subdomain: 'app' do
    authenticated :user do
      root :to => "home#index"
    end

    devise_for :users, skip: [:sessions, :registrations]
    devise_scope :user do
      get "/login" => "devise/sessions#new"
      delete "/logout" => "devise/sessions#destroy"
      get "/register" => "devise/registrations#new"
    end
  end

  constraints subdomain: 'api', defaults: { format: :json } do
    scope module: 'api/v1', constraints: ApiConstraints.new(version: 1, default: :true) do
      resources :notebooks, param: :carrier_identifier, only: [:index, :create, :show, :update]
    end
  end

end
