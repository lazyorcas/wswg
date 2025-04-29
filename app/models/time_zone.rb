class TimeZone < ApplicationRecord
  validates :name,
    presence: true,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:tzinfo).map(&:name) }

  def today
    @today ||= Time.current.in_time_zone(name).to_date
  end
end
