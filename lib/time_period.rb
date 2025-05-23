class TimePeriod
  attr_reader :time_zone, :time_period_symbol

  NIGHT_START_TIME = "18:00".freeze
  SYMBOLS = [
    :today,
    :tonight,
    :tomorrow,
    :this_week,
    :this_weekend,
    :next_week,
    :next_weekend,
    :all
  ].freeze

  def self.slugify(time_period_symbol)
    if time_period_symbol == :all
      nil
    else
      time_period_symbol.to_s.gsub("_", "-")
    end
  end

  SLUGS = SYMBOLS.map { |symbol| slugify(symbol) }.freeze
  SLUG_TO_SYMBOL_MAPPING = SLUGS.zip(SYMBOLS).to_h.freeze

  def initialize(time_zone, time_period_symbol)
    @time_zone = if time_zone.is_a?(String)
      TimeZone.new(name: time_zone)
    elsif time_zone.is_a?(TimeZone)
      time_zone
    else
      raise ArgumentError, "Invalid time zone: #{time_zone}"
    end

    if SYMBOLS.exclude?(time_period_symbol)
      raise ArgumentError, "Invalid time period: #{time_period_symbol}"
    end

    @time_period_symbol = time_period_symbol
  end

  def current_date
    @current_date ||= time_zone.current_date
  end

  def current_time
    @current_time ||= time_zone.current_time
  end

  def to_s
    @to_s ||= if today?
      "today"
    elsif tonight?
      "tonight"
    elsif tomorrow?
      "tomorrow"
    elsif this_week?
      "this week"
    elsif this_weekend?
      "this weekend"
    elsif next_week?
      "next week"
    elsif next_weekend?
      "next weekend"
    end
  end

  def to_sym
    time_period_symbol
  end

  def date_range_s
    if today? || tonight? || tomorrow?
      start_date.strftime("%B %d")
    elsif all?
      nil
    else
      "#{start_date.strftime("%B %d")} - #{end_date.strftime("%B %d")}"
    end
  end

  def slug
    @slug ||= self.class.slugify(time_period_symbol)
  end

  def start_date
    @start_date ||= if today? || tonight? || all?
      current_date
    elsif tomorrow?
      current_date + 1.day
    elsif this_week?
      [ current_date.beginning_of_week, current_date ].max
    elsif this_weekend?
      [ current_date.beginning_of_week.next_occurring(:saturday), current_date ].max
    elsif next_week?
      current_date.end_of_week.next_occurring(:monday)
    elsif next_weekend?
      current_date.end_of_week.next_occurring(:saturday)
    end
  end

  def end_date
    @end_date ||= if today? || tonight?
      current_date
    elsif tomorrow?
      current_date + 1.day
    elsif this_week?
      current_date.end_of_week
    elsif this_weekend?
      current_date.beginning_of_week.next_occurring(:sunday)
    elsif next_week?
      current_date.end_of_week.next_occurring(:sunday)
    elsif next_weekend?
      current_date.end_of_week.next_occurring(:sunday)
    end
  end

  def start_time
    @start_time ||= if today? || this_week? || all?
      current_time
    elsif tonight?
      NIGHT_START_TIME
    end
  end

  SYMBOLS.each do |time_period_symbol|
    define_method("#{time_period_symbol}?") do
      time_period_symbol == self.time_period_symbol
    end
  end
end
