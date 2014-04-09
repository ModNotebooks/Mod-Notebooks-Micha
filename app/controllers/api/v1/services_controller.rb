class Api::V1::ServicesController < Api::BaseController

  before_filter :find_service, only: [:show, :update, :destroy]

  doorkeeper_for :all

  def index
    respond_with @user.services do |f|
      f.json { render json: @user.services }
    end
  end

  def show
    respond_with @service do |f|
      f.json { render json: @service, status: :unprocessable_entity }
    end
  end

  def create
    provider = create_params.fetch(:provider)
    klass    = "#{provider}_service".classify.constantize
    uid      = create_params[:uid]
    uid      = uid.blank? ? "#{provider}_uid_placeholder" : uid
    attributes = {
      token: create_params[:token],
      secret: create_params[:secret],
      refresh_token: create_params[:refresh_token],
      uid: uid,
      expires_at: expires_at }


    if @service = @user.services.with_deleted.provider(provider).first
      @service.restore if @service.deleted?
      @service.assign_attributes(attributes)
    else
      @service = klass.new(attributes.reverse_merge(create_params))
      @service.user = @user
    end

    if @service.save
      # When someone connects a service immediately start
      # syncing it
      Syncer.async(:sync_service, @service.id)

      respond_with @service do |f|
        f.json { render json: @service, status: :created }
      end
    else
      respond_with @service, status: :unprocessable_entity
    end
  end

  def update
    @service.update(update_params)

    respond_with @service do |f|
      f.json { render json: @service }
    end
  end

  def destroy
    @service.destroy
    respond_with :no_content
  end

  private
    def create_params
      params.require(:service).permit(
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
      Time.zone = 'UTC'
      Time.zone.at(time.to_i / 1000)
    rescue
      nil
    end

end
