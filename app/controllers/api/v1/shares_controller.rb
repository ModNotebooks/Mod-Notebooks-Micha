class Api::V1::SharesController < Api::BaseController
  before_filter :find_shareable, only: [:create]
  before_filter :find_share, only: [:show, :destroy]

  doorkeeper_for :all, except: [:show]

  def destroy
    @share.destroy!
    respond_with :no_content
  end

  def create
    share = Share.new(shareable: @shareable)

    if share.save
      respond_with share
    else
      respond_with share, status: :unprocessable_entity
    end
  end

  def show
    respond_with @share
  end

  private
    def create_params
      params.require(:share).permit(:shareable_type, :shareable_id)
    end

    def find_share
      @share = Share.find_by_token!(params[:token])
    end

    def find_shareable
      type  = create_params.fetch(:shareable_type).downcase
      klass = type.classify.constantize
      association = type.pluralize

      @shareable = @user.try(association.to_sym).try(:find_by_id!, create_params.fetch(:shareable_id))
    end

end
