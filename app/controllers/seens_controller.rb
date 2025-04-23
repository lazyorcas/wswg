class SeensController < ApplicationController
  before_action :require_user!

  def create
    build_seen
    @seen.save!
  end

  private

  def build_seen
    @seen ||= seen_scope.build
    @seen.attributes = seen_params
  end

  def seen_scope
    Current.user.seens
  end

  def seen_params
    seen_params = params[:seen]
    seen_params ? seen_params.permit(:seenable_id, :seenable_type) : {}
  end
end
