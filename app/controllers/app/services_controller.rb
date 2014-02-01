class App::ServicesController < ApplicationController
  respond_to :html

  def success
    @auth_hash = auth_hash
    respond_with @auth_hash, layout: false
  end

  def failure
    @auth_hash = auth_hash
    respond_with @auth_hash do |format|
      format.html { render layout: false }
    end
  end

  protected

    def auth_hash
      request.env['omniauth.auth']
    end

end
