class Api::BaseController < ApplicationController
  respond_to :json
  before_filter :find_user

  skip_before_filter :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  protected
    def find_user
      @user ||= User.find_by_id!(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
end
