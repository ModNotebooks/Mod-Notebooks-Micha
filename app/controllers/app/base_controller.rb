class App::BaseController < ApplicationController
  if Rails.env.staging?
    http_basic_authenticate_with name: ENV['HTTP_BASIC_AUTH_USERNAME'], password: ENV['HTTP_BASIC_AUTH_PASSWORD']
  end
end
