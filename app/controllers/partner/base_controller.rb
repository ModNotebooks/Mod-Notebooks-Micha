class Partner::BaseController < ApplicationController
  layout 'application-partner'

  http_basic_authenticate_with name: ENV["MANAGEMENT_HTTP_BASIC_AUTH_USER"],
    password: ENV["MANAGEMENT_HTTP_BASIC_AUTH_PASSWORD"]
end
