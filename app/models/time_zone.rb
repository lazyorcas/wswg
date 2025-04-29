class TimeZone < ApplicationRecord
  has_many :cities
  has_many :city_sources, through: :cities

  validates :name,
    presence: true,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:tzinfo).map(&:name) }

  def today
    @today ||= now.to_date
  end

  def now
    @time_now ||= Time.current.in_time_zone(name)
  end
end
