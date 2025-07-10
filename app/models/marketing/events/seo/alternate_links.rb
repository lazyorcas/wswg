module Marketing::Events::SEO::AlternateLinks
  MAPPING = {
    today: [ :tonight, :tomorrow, :this_week, :this_weekend, :all ],
    tonight: [ :tomorrow, :this_week, :this_weekend, :all ],
    tomorrow: [ :this_week, :this_weekend, :all ],
    this_week: [ :this_weekend, :next_week, :all ],
    this_weekend: [ :next_weekend, :next_week, :all ],
    next_week: [ :next_weekend, :all ],
    next_weekend: [ :all ],
    all: [ :today, :tonight, :tomorrow, :this_week, :this_weekend, :next_week, :next_weekend ]
  }.freeze

  def build_alternate_links_attributes
    MAPPING[time_period_symbol].map do |time_period_symbol|
      {
        href: build_alternate_link_path(time_period_symbol),
        title: build_alternate_link_title(time_period_symbol)
      }
    end
  end

  def build_alternate_link_path(time_period_symbol)
    raise NotImplementedError
  end

  def build_alternate_link_title(time_period_symbol)
    raise NotImplementedError
  end

  private

  def time_period_symbol
    raise NotImplementedError
  end
end
