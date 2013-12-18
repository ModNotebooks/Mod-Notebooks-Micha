class Api::BaseController < ApplicationController
  respond_to :json

  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do
    render text: "not found", status: :not_found
  end
end
