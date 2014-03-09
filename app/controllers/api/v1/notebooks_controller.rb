class Api::V1::NotebooksController < Api::BaseController
  before_filter :find_notebooks
  before_filter :find_notebook_by_notebook_identifier, only: [:create, :exists]
  before_filter :find_notebook, only: [:show, :update, :share]

  doorkeeper_for :all

  def index
    if index_params.has_key?(:ids)
      @notebooks = @notebooks.where(id: index_params.fetch(:ids))
    end

    respond_with @notebooks
  end

  def show
    respond_with @notebook
  end

  def share
    respond_with @notebook.shares.create
  end

  def exists
    render json: { notebook: "exists" }
  end

  def create
    if @notebook.submit!(@user, create_params.slice(:name, :handle_method))
      respond_with @notebook, status: :created
    else
      respond_with @notebook, status: :unprocessable_entity
    end
  end

  def update
    @notebook.update(update_params)
    respond_with @notebook
  end

  private
    def index_params
      params.permit(ids: [])
    end

    def update_params
      params.require(:notebook).permit(:name)
    end

    def create_params
      params.require(:notebook).permit(:notebook_identifier, :name, :handle_method, :user_id)
    end

    def find_notebooks
      @notebooks = @user.notebooks
    end

    def find_notebook_by_notebook_identifier
      @notebook = Notebook.created.unreserved.find_by_notebook_identifier!(create_params.fetch(:notebook_identifier))
    end

    def find_notebook
      @notebook = @notebooks.find_by_id!(params[:id])
    end
end
