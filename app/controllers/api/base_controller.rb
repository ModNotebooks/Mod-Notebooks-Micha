class Api::BaseController < ApplicationController
  respond_to :json
  before_filter :find_user

  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  protected
    def find_notebook
      if @user
        @notebook = @user.notebooks.find_by_id!(params[:notebook_id] || params[:id])
      else
        @notebook = Notebook.find_by_id!(params[:notebook_id] || params[:id])
      end
    end

    def find_user
      user_id = params[:user_id].presence

      if user_id == 'me' && doorkeeper_token
        @user = User.find_by_id!(doorkeeper_token.resource_owner_id)
      elsif user_id
        @user = User.find_by_id!(user_id)
      end
    end

    def for_me
      request.params[:user_id] == "me"
    end

    def not_for_me
      !for_me
    end
end
