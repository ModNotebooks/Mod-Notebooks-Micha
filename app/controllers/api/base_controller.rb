class Api::BaseController < ApplicationController
  respond_to :json

  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do
    head :not_found
  end

  protected
    def find_notebook
      @notebook = current_user.notebooks.find_by_id!(params[:notebook_id] || params[:id])
    end
end
