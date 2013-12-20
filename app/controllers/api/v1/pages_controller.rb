class Api::V1::PagesController < Api::BaseController
  before_filter :authenticate_user_from_token!
  before_filter :find_notebook, only: [:index]
  before_filter :find_page, only: [:show]

  def index
    respond_with @notebook.pages
  end

  def show
    respond_with @page
  end

  private

    def find_page
      @page = current_user.pages.find_by_id!(params[:id])
    end

end
