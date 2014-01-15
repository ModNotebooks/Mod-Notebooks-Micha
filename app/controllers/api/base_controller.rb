class Api::BaseController < ApplicationController
  respond_to :json
  before_filter :find_user

  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  protected
    def find_user
      @user ||= User.find_by_id!(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
end
