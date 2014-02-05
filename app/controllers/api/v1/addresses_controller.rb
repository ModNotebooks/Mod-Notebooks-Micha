class Api::V1::AddressesController < Api::BaseController
  doorkeeper_for :all

  def show
    respond_with @user.preferences.address
  end

  def update
    address = @user.preferences.address

    if address.update(update_params)
      head :no_content
    else
      respond_with address, status: :unprocessable_entity
    end
  end

  private
    def update_params
      params.require(:address).permit(:name, :line_1, :line_2, :city, :region, :postal_code, :country)
    end
end
