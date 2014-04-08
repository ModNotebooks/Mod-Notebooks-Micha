class Partner::NotebooksController < Partner::BaseController

  before_filter :find_notebook, only: [:return, :recycle, :upload]

  respond_to :html, :json

  def index
    @notebooks = (index_params.has_key?(:q) ? search(index_params.fetch(:q))
                                            : Notebook.order('updated_at DESC')).page(params[:page])
  end

  def show
    id = show_params.fetch(:id).downcase

    if id.match(Patterns::NOTEBOOK_IDENTIFIER_PATTERN)
      @notebook = Notebook.find_by_notebook_identifier!(id.downcase)
    else
      @notebook = Notebook.find(id)
    end

    respond_with @notebook
  end

  def upload
    begin
      if @notebook.upload!(upload_params.fetch(:pdf))
        respond_with @notebook, status: :ok
      else
        respond_with @notebook, status: :unprocessable_entity
      end
    rescue Transitions::InvalidTransition => e
      respond_with @notebook, status: :unprocessable_entity
    end
  end

  def recycle
    if @notebook.recycle!
      flash[:success] = "Notebook recycled."
    else
      flash[:warning] = "Notebook could not be recycled."
    end

    redirect_to request.referer
  end

  def return
    if @notebook.return!
      flash[:success] = "Notebook returned."
    else
      flash[:warning] = "Notebook could not be returned."
    end

    redirect_to request.referer
  end

  private
    def index_params
      params.permit(:page, :utf8, :q)
    end

    def show_params
      params.permit(:id)
    end

    def upload_params
      params.require(:notebook).permit(:pdf)
    end

    def find_notebook
      @notebook = Notebook.reserved.find(params[:id])
    end

    def find_notebook_by_notebook_identifier
      @notebook = Notebook.find_by_notebook_identifier!(upload_params.fetch(:notebook_identifier).downcase)
    end

    def search(query)
      Notebook.reserved.fuzzy_search(query)
    end
end
