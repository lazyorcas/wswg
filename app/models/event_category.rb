class EventCategory
  attr_reader :symbol

  SYMBOLS = [
    :events,
    :concerts,
    :meetups
  ].freeze

  def self.slugify(symbol)
    symbol.to_s.gsub("_", "-")
  end

  SLUGS = SYMBOLS.map { |symbol| slugify(symbol) }.freeze
  SLUG_TO_SYMBOL_MAPPING = SLUGS.zip(SYMBOLS).to_h.freeze
  SYMBOL_TO_SLUG_MAPPING = SYMBOLS.zip(SLUGS).to_h.freeze

  def self.stringify(symbol)
    symbol.to_s.humanize(capitalize: false)
  end

  STRINGS = SYMBOLS.map { |symbol| stringify(symbol) }.freeze
  SYMBOL_TO_STRING_MAPPING = SYMBOLS.zip(STRINGS).to_h.freeze

  def initialize(symbol)
    if SYMBOLS.exclude?(symbol)
      raise ArgumentError, "Invalid event category: #{symbol}"
    end

    @symbol = symbol
  end

  def to_s
    @to_s ||= self.class.stringify(symbol)
  end

  def slug
    @slug ||= self.class.slugify(symbol)
  end

  def query
    if concerts?
      "music concerts"
    else
      to_s
    end
  end

  SYMBOLS.each do |symbol|
    define_method("#{symbol}?") do
      symbol == self.symbol
    end
  end
end
