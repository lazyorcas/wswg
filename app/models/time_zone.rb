class TimeZone
  include ActiveModel::Model

  attr_accessor :name

  validate :valid_name?

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

  def current_date_time
    @current_date_time ||= now.strftime("%Y-%m-%d %H:%M:%S")
  end

  def current_date_without_year
    @current_date_without_year ||= now.strftime("%m-%d")
  end

  def current_year
    @current_year ||= now.year
  end

  private

  def valid_name?
    now
    true
  rescue
    errors.add(:name, "is invalid")
  end
end
