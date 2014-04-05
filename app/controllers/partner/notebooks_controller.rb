class Partner::NotebooksController < Partner::BaseController
  before_filter :find_notebook_by_notebook_identifier, only: [:upload]
  before_filter :find_notebook, only: [:return, :recycle]

  def index
    @notebooks = (index_params.has_key?(:q) ? search(index_params.fetch(:q)) : Notebook).page(params[:page])
  end

  def upload
    begin
      if @notebook.upload(upload_params.fetch(:pdf).tempfile)
        head :ok
      else
        head :unprocessable_entity
      end
    rescue Transitions::InvalidTransition => e
      head :unprocessable_entity
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

    def upload_params
      params.require(:notebook).permit(:notebook_identifier, :pdf)
    end

    def handle_params
      params.permit(:id)
    end

    def find_notebook
      @notebook = Notebook.reserved.find(handle_params.fetch(:id))
    end

    def find_notebook_by_notebook_identifier
      @notebook = Notebook.find_by_notebook_identifier!(upload_params.fetch(:notebook_identifier).downcase)
    end

    def search(query)
      Notebook.reserved.fuzzy_search(query)
    end
end
