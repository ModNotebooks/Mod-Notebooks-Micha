class Api::V1::ServicesController < Api::BaseController

  before_filter :find_service, only: [:show, :update, :destroy]

  doorkeeper_for :all

  def index
    respond_with @user.services do |f|
      f.json { render json: @user.services, each_serializer: ServiceSerializer}
    end
  end

  def show
    respond_with :service
  end

  def create
    provider = create_params.fetch(:provider)

    service_klass = "#{provider}_service".classify.constantize
    service = @user.services
                .with_deleted
                .provider(provider)
                .find_by_uid(create_params.fetch(:uid).to_s)

    if service.present?
      service.assign_attributes(create_params.slice(:token, :secret, :refresh_token))
      service.expires_at = expires_at
      service.restore! if service.deleted?
    elsif @user.services.provider(provider).blank?
      service      = service_klass.new(create_params)
      service.user = @user
    end

    if service.save
      head :created
    else
      respond_with service, status: :unprocessable_entity
    end
  end

  def update
    @service.update(update_params)
    respond_with @service
  end

  def destroy
    @service.destroy!
    respond_with :no_content
  end

  private
    def create_params
      params.require(:service).permit(
        :user_id,
        :provider,
        :uid,
        :name,
        :email,
        :nickname,
        :token,
        :secret,
        :refresh_token,
        :expires_at,
        meta: {}
      )
    end

    def update_params
      params.require(:service).permit()
    end

    def find_service
      @service = @user.services.find_by_id!(params[:id])
    end

    def expires_at
      time = create_params.fetch(:expires_at)
      if time.to_f.to_s === "0"
        time
      else
        Time.zone = 'UTC'
        Time.zone.at(time.to_i)
      end
    rescue
      nil
    end

end
