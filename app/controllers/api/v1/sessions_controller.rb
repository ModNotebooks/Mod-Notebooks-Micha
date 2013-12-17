class Api::V1::SessionsController < Devise::SessionsController
  before_filter :authenticate_user_from_token!, except: [ :new, :create ]
end
