class Api::V1::NotebooksController < Api::BaseController
  before_filter :find_notebook, only: [:show, :update]

  doorkeeper_for :all, scopes: ['public'], if: :for_me
  doorkeeper_for :all, scopes: ['admin'], if: :not_for_me

  def index
    if @user
      respond_with @user.notebooks
    else
      respond_with Notebook.all
    end
  end

  def show
    respond_with @notebook
  end

  def create
    notebook = @user.notebooks.build(notebook_create_params)

    if notebook.save
      respond_with notebook, status: :created
    else
      respond_with notebook, status: :conflict
    end
  end

  def update
    @notebook.update(notebook_update_params)
    respond_with @notebook
  end

  private
    def notebook_update_params
      params.require(:notebook).permit(:name)
    end

    def notebook_create_params
      params.require(:notebook).permit(:notebook_identifier, :name)
    end
end
