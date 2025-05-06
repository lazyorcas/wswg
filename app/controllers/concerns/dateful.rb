module Dateful
  extend ActiveSupport::Concern

  included do
    helper_method :current_date, :current_wday, :sunday?
  end

  def current_wday
    @current_wday ||= (current_date.wday + 6) % 7
  end

  def current_date
    @current_date ||= Current.user.city.time_zone.current_date
  end

  def sunday?
    current_wday == 6
  end
end
