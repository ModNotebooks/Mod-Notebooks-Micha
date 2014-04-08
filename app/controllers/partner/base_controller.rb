class Partner::BaseController < ApplicationController
  layout 'application-partner'

  http_basic_authenticate_with name: ENV["MANAGEMENT_HTTP_BASIC_AUTH_USER"],
    password: ENV["MANAGEMENT_HTTP_BASIC_AUTH_PASSWORD"]

  rescue_from ActiveRecord::RecordNotFound do |e|
    respond_to do |f|
      f.html { render :nothing, status: :not_found }
      f.json { head :not_found }
    end
  end
end
