class Api::V1::PreferencesController < Api::BaseController
  doorkeeper_for :all

  def show
    respond_with @user.preferences
  end

  def update
    preferences = @user.preferences

    if preferences.update(update_params)
      head :no_content
    else
      respond_with preferences, status: :unprocessable_entity
    end
  end

  private
    def update_params
      params.require(:preferences).permit(
        address_attributes: [:name, :line_1, :line_2, :city, :region, :postal_code, :country])
    end
end
