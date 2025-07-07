class Home::Events::RedirectsController < ApplicationController
  def show
    head(:gone)
  end
end
