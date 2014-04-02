class Partner::BaseController < ApplicationController
  respond_to :json

  skip_before_filter :verify_authenticity_token

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end
end
