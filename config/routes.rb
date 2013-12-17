Mod::Application.routes.draw do

  authenticated :user do
    root :to => "home#index"
  end

  constraints subdomain: 'api', defaults: { format: :json } do
    devise_for :users

    scope module: 'api/v1', constraints: ApiConstraints.new(version: 1, default: :true) do
    end
  end

end
