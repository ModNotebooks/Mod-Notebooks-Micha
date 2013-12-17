class Api::V1::RegistrationsController < DeviseInvitable::RegistrationsController
  before_filter :authenticate_user_from_token!, except: [ :new, :create, :cancel ]
  skip_before_filter :authenticate_scope!
end
