class Api::V1::NotebookSettingsController < Api::BaseController
  doorkeeper_for :all

  def index
    @notebook_settings = NotebookSetting.all
    respond_with @notebook_settings
  end
end
