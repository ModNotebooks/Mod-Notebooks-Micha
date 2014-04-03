class Partner::NotebooksController < Partner::BaseController

  def index
    @notebooks = (index_params.has_key?(:q) ? search(index_params.fetch(:q)) : Notebook).page(params[:page])
  end

  private

  def index_params
    params.permit(:page, :utf8, :q)
  end

  def search(query)
    Notebook.fuzzy_search(notebook_identifier: query)
  end
end
