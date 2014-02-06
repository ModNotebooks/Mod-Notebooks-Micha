class App::ServicesController < App::BaseController
  respond_to :html

  def success
    @auth_hash = auth_hash
    respond_with @auth_hash, layout: false
  end

  def failure
    @error_hash = error_hash
    respond_with @error_hash, layout: false
  end

  protected

    def auth_hash
      request.env['omniauth.auth']
    end

    def error_hash
      { provider: request.env['omniauth.error.strategy'].name,
        error: request.env['omniauth.error.type'] }
    end

end
