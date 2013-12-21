class Api::V1::PagesController < Api::BaseController
  before_filter :find_notebook, only: [:index]
  before_filter :find_page, only: [:show]

  doorkeeper_for :all, scopes: ['public'], if: :for_me
  doorkeeper_for :all, scopes: ['admin'], if: :not_for_me

  def index
    respond_with @notebook.pages
  end

  def show
    respond_with @page
  end

  private

    def find_page
      @page = @notebook.pages.find_by_id!(params[:id])
    end

end
