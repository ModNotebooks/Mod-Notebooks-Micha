class Api::V1::UsersController < Api::BaseController
  before_filter :find_user, only: [ :update, :delete, :show ]

  doorkeeper_for :show, :update, :destroy, scopes: ['public'], if: :for_me
  doorkeeper_for :show, :update, :destroy, scopes: ['admin'], if: :not_for_me

  def create
    user = User.new(create_params)

    if user.save
      respond_with user, status: :created
    else
      respond_with user, status: :unprocessable_entity
    end
  end

  def show
    respond_with @user
  end

  def update
    if @user.update_without_password(update_params)
      head :no_content
    else
      respond_with @user, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private

    def create_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def update_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end

end
