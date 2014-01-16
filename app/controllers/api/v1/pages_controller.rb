class Api::V1::PagesController < Api::BaseController
  before_filter :find_pages
  before_filter :find_page, only: [:show, :share]

  doorkeeper_for :all

  def index
    if index_params.has_key?(:ids)
      @pages = @pages.where(id: index_params.fetch(:ids))
    end

    if index_params.has_key?(:notebook_id)
      @pages = @pages.where(notebook_id: index_params.fetch(:notebook_id))
    end

    respond_with @pages
  end

  def show
    respond_with @page
  end

  def share
    respond_with @page.shares.create
  end

  private
    def index_params
      params.permit(:notebook_id, ids: [])
    end

    def find_pages
      @pages = @user.pages
    end

    def find_page
      @page = @pages.find_by_id!(params[:id])
    end

end
