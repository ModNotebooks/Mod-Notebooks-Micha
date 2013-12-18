class Api::BaseController < ApplicationController
  respond_to :json

  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end
end
