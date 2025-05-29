module Temporal
  extend ActiveSupport::Concern

  included do
    helper_method :current_date
  end

  def time_zone
    @time_zone ||= Current.user.city.time_zone
  end

  def current_date
    @current_date ||= time_zone.current_date
  end
end
