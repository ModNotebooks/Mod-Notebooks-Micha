class Api::V1::NotebooksController < Api::BaseController
  before_filter :find_notebook, only: [:show, :update]

  doorkeeper_for :upload, :process, scopes: ['admin'] # Never Public
  doorkeeper_for :index, :show, :create, :update, scopes: ['public'], if: :for_me
  doorkeeper_for :index, :show, :create, :update, scopes: ['admin'], if: :not_for_me

  def index
    if @user
      respond_with @user.notebooks
    else
      respond_with Notebook.with_deleted.all
    end
  end

  def show
    respond_with @notebook
  end

  def create
    notebook = @user.notebooks.build(create_params)

    if notebook.save
      respond_with notebook, status: :created
    else
      respond_with notebook, status: :conflict
    end
  end

  def update
    @notebook.update(update_params)
    respond_with @notebook
  end

  private
    def update_params
      p = params.require(:notebook)

      if requester.try?(:admin)
        p.permit(:name, :notebook_identifier)
      else
        p.permit(:name)
      end
    end

    def create_params
      params.require(:notebook).permit(:notebook_identifier, :name)
    end
end
