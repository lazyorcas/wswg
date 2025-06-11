class TimeZone
  include ActiveModel::Model

  attr_accessor :name

  validates :name,
    presence: true,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:tzinfo).map(&:name) }

  def now
    @now ||= Time.current.in_time_zone(name)
  end

  def current_hour
    @current_hour ||= now.hour
  end

  def current_time
    @current_time ||= now.strftime("%H:%M:%S")
  end

  def current_date
    @current_date ||= now.to_date
  end

  def current_date_without_year
    @current_date_without_year ||= now.strftime("%m-%d")
  end

  # Monday is 0, Sunday is 6
  def current_wday
    @current_wday ||= (now.wday + 6) % 7
  end

  def current_year
    @current_year ||= now.year
  end
end
