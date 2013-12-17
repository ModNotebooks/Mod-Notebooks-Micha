class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def authenticate_with_api_key
    api_key = request.headers["Authorization"] || params[:api_key]
    sign_in User.find_by_api_key(api_key)
  end
end
