class Api::V1::UsersController < Api::BaseController
  doorkeeper_for :all, except: [:create]

  def create
    user = User.new(create_params)

    if user.save
      respond_with user do |f|
        f.json { render json: user, status: :created }
      end
    else
      respond_with user, status: :unprocessable_entity
    end
  end

  def show
    respond_with @user
  end

  def update
    method = update_params.has_key?(:current_password) ? :update_with_password : :update_without_password

    if @user.send(method, update_params)
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
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
    end

end
