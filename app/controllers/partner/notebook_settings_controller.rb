class Partner::NotebookSettingsController < Partner::BaseController
  respond_to :html

  before_filter :find_notebook_setting, only: [:edit, :update, :destroy]

  def index
    @notebook_setting = NotebookSetting.new
    @notebook_settings = NotebookSetting.order('created_at DESC').all
    respond_with @notebook_settings
  end

  def create
    @notebook_setting = NotebookSetting.new(create_params)

    if @notebook_setting.save
      redirect_to action: :index
      flash[:success] = "Notebook Setting created."
    else
      flash[:error] = "Notebook Setting could not be saved. #{@notebook_setting.errors.full_messages.join(",")}"
      @notebook_settings = NotebookSetting.all
      render "index"
    end
  end

  def update
    if @notebook_setting.update(update_params)
      redirect_to action: :index
      flash[:success] = "Notebook Setting updated."
    else
      flash[:error] = "Notebook Setting could not be saved. #{@notebook_setting.errors.full_messages.join(",")}"
      render "edit"
    end
  end

  def edit
    respond_with @notebook_setting
  end

  def destroy
    if @notebook_setting.destroy
      redirect_to action: :index
      flash[:success] = "Notebook Setting deleted."
    else
      redirect_to action: :index
      flash[:error] = "Notebook Setting could not be deleted."
    end
  end

  private
    def create_params
      params.require(:notebook_setting).permit(:name, :color_code, :color, :cover_image)
    end

    def update_params
      params.require(:notebook_setting).permit(:name, :color, :color_code, :cover_image, :remove_cover_image)
    end

    def find_notebook_setting
      @notebook_setting = NotebookSetting.find(params[:id])
    end
end
