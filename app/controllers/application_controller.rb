class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

    def authenticate_user_from_token!
      token, email = nil
      auth = request.headers["Authorization"].presence

      if auth
        parts = auth.split(':')
        email = parts.first
        token = parts.last
      else
        email = params[:email].presence
        token = params[:token].presence
      end

      user  = email && User.find_by_email(email)

      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in user, store: false
      else
        head :not_found
      end
    end
end
