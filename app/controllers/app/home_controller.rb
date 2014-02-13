class App::HomeController < App::BaseController

  layout "application-app"

  def index; end

  def order
    redirect_to 'https://shopify.com'
  end

  def store
    redirect_to 'https://shopify.com'
  end

  def guide
    render 'guide', layout: false
  end

  def layout
    render 'layout', layout: false
  end
end
