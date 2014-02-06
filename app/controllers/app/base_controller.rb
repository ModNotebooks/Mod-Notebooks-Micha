class App::BaseController < ApplicationController
  if Rails.env.staging?
    http_basic_authenticate_with name: "dhh", password: "secret"
  end
end
