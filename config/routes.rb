Mod::Application.routes.draw do

  authenticated :user do
    root :to => "home#index"
  end

  constraints subdomain: 'api', defaults: { format: :json } do
    scope module: 'api/v1', constraints: ApiConstraints.new(version: 1, default: :true) do
      devise_for :users, controllers: {
        # Only need to map registrations. All others are routed to correct
        # controller because of scope
        registrations: 'api/v1/registrations'
      }
    end
  end

end
