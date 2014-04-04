class Partner::NotebooksController < Partner::BaseController
  before_filter :find_notebook, only: [:upload]

  def index
    @notebooks = (index_params.has_key?(:q) ? search(index_params.fetch(:q)) : Notebook.reserved).page(params[:page])
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

  private
    def index_params
      params.permit(:page, :utf8, :q)
    end

    def upload_params
      params.require(:notebook).permit(:notebook_identifier, :pdf)
    end

    def find_notebook
      @notebook = Notebook.reserved.find_by_notebook_identifier!(upload_params.fetch(:notebook_identifier).downcase)
    end

    def search(query)
      Notebook.reserved.fuzzy_search(notebook_identifier: query)
    end
end
