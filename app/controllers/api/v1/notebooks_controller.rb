class Api::V1::NotebooksController < Api::BaseController
  before_filter :authenticate_user_from_token!
  before_filter :find_notebook, only: [:show, :update]

  def index
    respond_with current_user.notebooks
  end

  def show
    respond_with @notebook
  end

  def create
    notebook = current_user.notebooks.build(notebook_create_params)

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

  def find_notebook
    @notebook = current_user.notebooks.find_by_id!(params[:id])
  end
end
