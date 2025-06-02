class CurrentUserController < ApplicationController
  before_action :require_user!

  def edit
  end

  def update
    Current.user.update!(user_params)
    redirect_to(map_path)
  end

  private

  def user_params
    user_params = params[:user]
    user_params ? user_params.permit(:city_id) : {}
  end
end
