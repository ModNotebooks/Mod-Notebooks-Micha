class Api::V1::PasswordsController < Api::BaseController
  before_filter :find_reset_user

  def reset
    @reset_user.send_reset_password_instructions
    head :no_content
  end

  private
    def reset_params
      params.require(:email)
    end

    def find_reset_user
      @reset_user = User.find_by_email!(reset_params)
    end
end
