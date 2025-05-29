module Temporal
  extend ActiveSupport::Concern

  included do
    helper_method :current_date
  end

  def time_zone
    @time_zone ||= Current.user.present? ?
      Current.user.city.time_zone :
      Current.city.time_zone
  end

  def current_date
    @current_date ||= time_zone.current_date
  end

  def current_hour
    @current_hour ||= time_zone.current_hour
  end
end
