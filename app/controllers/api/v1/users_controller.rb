class Api::V1::UsersController < Api::BaseController
  doorkeeper_for :all, except: [:create]

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
