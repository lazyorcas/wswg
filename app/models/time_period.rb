class TimePeriod
  include Localizable

  attr_reader :time_zone, :symbol

  NIGHT_START_TIME = "18:00:00".freeze
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

  def self.slugify(symbol)
    symbol.to_s.gsub("_", "-")
  end

  SLUGS = SYMBOLS.map { |symbol| slugify(symbol) }.freeze
  SLUG_TO_SYMBOL_MAPPING = SLUGS.zip(SYMBOLS).to_h.freeze

  def self.stringify(symbol)
    if symbol == :all
      nil
    else
      symbol.to_s.humanize(capitalize: false)
    end
  end

  def initialize(time_zone, symbol)
    @time_zone = if time_zone.is_a?(String)
      TimeZone.new(name: time_zone)
    elsif time_zone.is_a?(TimeZone)
      time_zone
    else
      raise ArgumentError, "Invalid time zone: #{time_zone}"
    end

    if SYMBOLS.exclude?(symbol)
      raise ArgumentError, "Invalid time period: #{symbol}"
    end

    @symbol = symbol
  end

  def name
    @name ||= self.class.stringify(symbol)
  end

  def slug
    @slug ||= self.class.slugify(symbol)
  end

  def current_date
    @current_date ||= time_zone.current_date
  end

  def current_time
    @current_time ||= time_zone.current_time
  end

  def start_date
    @start_date ||= if today? || tonight? || all?
      current_date
    elsif tomorrow?
      current_date + 1.day
    elsif this_week?
      current_date
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
      current_date.end_of_week
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
      [ NIGHT_START_TIME, current_time ].max
    end
  end

  SYMBOLS.each do |symbol|
    define_method("#{symbol}?") do
      symbol == self.symbol
    end
  end

  def localizable_field
    name
  end
end
