class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

    def authenticate_user_from_token!
      email = params[:email].presence
      user  = email && User.find_by_email(email)
      token = request.headers["Authorization"] || params[:token]

      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in user, store: false
      else
        head :not_found
      end
    end
end
