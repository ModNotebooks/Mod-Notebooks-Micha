class Partner::NotebooksController < Partner::BaseController
  helper_method :sort_column, :sort_direction, :query

  before_filter :find_notebook, only: [:return, :recycle, :upload, :pend]

  respond_to :html, :json

  def index
    @notebooks = (index_params.has_key?(:q) ? search(index_params.fetch(:q))
                                            : Notebook)

    @notebooks = @notebooks.order(sort_column + " " + sort_direction)
    @notebooks = @notebooks.page(params[:page])
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

  def pend
    if @notebook.pend!
      flash[:success] = "Notebook pended."
    else
      flash[:warning] = "Notebook could not be pended."
    end

    redirect_to request.referer
  end

  private
    def sort_column
      Notebook.column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end

    def query
      params[:q]
    end

    def index_params
      params.permit(:page, :utf8, :q, :direction, :sort)
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
      notebook_identifier = upload_params.fetch(:notebook_identifier).downcase
      @notebook = Notebook.find_by!("lower(notebook_identifier) = ?", notebook_identifier)
    end

    def search(q)
      if q["@"]
        Notebook.joins(:user).reserved.fuzzy_search({ users: { email: q.downcase }})
      else
        Notebook.fuzzy_search(q.downcase)
      end
    end
end
