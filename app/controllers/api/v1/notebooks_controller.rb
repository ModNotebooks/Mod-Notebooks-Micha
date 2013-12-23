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

  def upload
    notebook = Notebook.find_by_notebook_identifier!(upload_params.fetch(:notebook_identifier))

    if notebook.update(upload_params)
      notebook.upload
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def create
    notebook = @user.notebooks.build(create_params)

    if notebook.save
      head :created
    else
      respond_with notebook, status: :unprocessable_entity
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

    def upload_params
      params.require(:notebook).permit(:notebook_identifier, :pdf)
    end

    def create_params
      params.require(:notebook).permit(:notebook_identifier, :name, :handle_method)
    end
end
