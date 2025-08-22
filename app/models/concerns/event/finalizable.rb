module Event::Finalizable
  extend ActiveSupport::Concern

  included do
    before_validation :set_finalizable_from_and_until, if: :finalizable?
  end

  def set_finalizable_from_and_until
    self.finalizable_from = start_date_time_time - 24.hours
    self.finalizable_until = start_date_time_time
    nil
  end

  def finalizable?
    source.events_finalizable?
  end

  def finalizable_now?
    finalizable? &&
      city.time_zone.now >= finalizable_from &&
      city.time_zone.now <= finalizable_until
  end
end
