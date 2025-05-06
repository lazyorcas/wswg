class UserController < ApplicationController
  before_action :require_user!

  def no_credits; end
end
