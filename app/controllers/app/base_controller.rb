class App::BaseController < ApplicationController

  layout "singlepage"

  def index; end

  def guide
    render 'guide', layout: false
  end

  def layout
    render 'layout', layout: false
  end
end
