class HomeController < ApplicationController
  def index
    render text: "HELLO! #{ current_user.to_json }"
  end
end
