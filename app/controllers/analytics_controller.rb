class AnalyticsController < AdminController
  START_DATE = (4.weeks.ago.end_of_week + 1.day).to_date
  TIME_INTERVAL = "day"
  SEARCH_ENGINES = %w[google bing yandex yahoo duckduckgo baidu].freeze
  BOUNCE_DURATION = 10

  before_action :load_filters

  def index
    search_engine_referrers_where_clause = SEARCH_ENGINES.map { |engine| "referrer LIKE '%#{engine}%'" }.join(" OR ")
    search_engine_referrers_group_clause = "CASE " + SEARCH_ENGINES.map { |engine| "WHEN referrer LIKE '%#{engine}%' THEN '#{engine}'" }.join(" ") + " END"

    @visitors = Ahoy::Visit
      .legitimate
      .non_admin
      .group(Arel.sql(search_engine_referrers_group_clause))
      .order(Arel.sql(search_engine_referrers_group_clause))
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count("DISTINCT visitor_token")
      .transform_keys { |key| [ key[0].present? ? key[0] : "direct", key[1] ] }
    @unbounced_visitors = Ahoy::Visit
      .legitimate
      .non_admin
      .where("duration >= #{BOUNCE_DURATION}")
      .group(Arel.sql(search_engine_referrers_group_clause))
      .order(Arel.sql(search_engine_referrers_group_clause))
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count("DISTINCT visitor_token")
      .transform_keys { |key| [ key[0].present? ? key[0] : "direct", key[1] ] }
    @homepage_events = build_ahoy_events_page_events_data("Visited homepage")
    @bounces = Ahoy::Visit
      .legitimate
      .non_admin
      .where("duration < #{BOUNCE_DURATION}")
      .group(:duration)
      .order(:duration)
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count("DISTINCT visitor_token")
      .transform_keys { |key| [ "#{key[0]}s", key[1] ] }
    @bounces_by_search_engine = Ahoy::Visit
      .legitimate
      .non_admin
      .where(search_engine_referrers_where_clause)
      .where("duration < #{BOUNCE_DURATION}")
      .group(Arel.sql(search_engine_referrers_group_clause))
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count
    @pricing_page_events = build_ahoy_events_page_events_data("Visited pricing page")

    @city_events_page_events = Ahoy::Event
      .joins(:visit)
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: "Viewed events")
      .group("COALESCE(properties->>'event_category', 'events')")
      .order(Arel.sql("COALESCE(properties->>'event_category', 'events')"))
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count("DISTINCT ahoy_visits.visitor_token")
    @wday_views = Ahoy::Event
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .joins("INNER JOIN cities ON cities.name = ahoy_events.properties->>'city'")
      .where(name: "Viewed events")
      .where(time: @time_range)
      .group("COALESCE(properties->>'time_period', 'all')", Arel.sql("EXTRACT(DOW FROM ahoy_events.time AT TIME ZONE 'UTC' AT TIME ZONE cities.time_zone)"))
      .count
      .group_by { |(period, _), _| period }
      .map { |period, data|
        {
          name: period,
          data: data.each_with_object({}) do |((_, dow), count), hash|
            day = Date::DAYNAMES[dow.to_i]
            hash[day] = count
          end
        }
      }
      .map { |series|
        {
          name: series[:name],
          data: Date::DAYNAMES.rotate(1).each_with_object({}) do |day, hash|
            hash[day] = series[:data][day] || 0
          end
        }
      }
      .sort_by { |h| h[:name].to_s }
    @nearby_events_page_views = Ahoy::Event
      .joins(:visit)
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: "Viewed events")
      .where("(properties->>'nearby')::boolean IS TRUE")
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count("DISTINCT ahoy_visits.visitor_token")
    @nearby_events_city_views = Ahoy::Event
      .joins(:visit)
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: "Viewed events")
      .where("(properties->>'nearby')::boolean IS TRUE")
      .where(time: @time_range)
      .group("properties->>'city'")
      .count("DISTINCT ahoy_visits.visitor_token")
      .sort_by { |(_, count)| count }
      .reverse

    @search_queries = Ahoy::Event
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: [ "Searched", "Searched on map" ])
      .where("properties->>'query' IS NOT NULL")
      .where(time: @time_range)
      .order(time: :desc)
      .pluck(:time, Arel.sql("properties->>'query'"))
    @searches = build_ahoy_events_page_events_data("Searched")
    @viewed_event_events = Ahoy::Event
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: "Viewed event")
      .where(time: @time_range)
      .group("properties->>'source'")
      .order(Arel.sql("properties->>'source'"))
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count
    @map_page_events = build_ahoy_events_page_events_data("Visited map page")

    @visitor_retention = []
    qualified_visitor_tokens_for_retention = Ahoy::Visit
      .legitimate
      .non_admin
      .where("user_id IS NOT NULL OR duration >= #{BOUNCE_DURATION}")
      .pluck(:visitor_token)
    qualified_visitor_tokens_for_retention = Ahoy::Visit
      .where(visitor_token: qualified_visitor_tokens_for_retention)
      .group(:visitor_token)
      .minimum(:started_at)
      .select { |_, started_at| (started_at + 1.send(@time_interval.to_sym)).past? }
      .map { |visitor_token, _| visitor_token }
    visits_h = Ahoy::Visit
      .where(started_at: @time_range)
      .where(visitor_token: qualified_visitor_tokens_for_retention)
      .group(:visitor_token)
      .count("DISTINCT DATE_TRUNC('#{@time_interval.upcase}', started_at)")
    visit_counts = visits_h.values
    if visit_counts.present?
      (visit_counts.min..visit_counts.max).each do |day|
        @visitor_retention << [ "#{day}#{ordinal_suffix(day)}", visit_counts.count { |count| count >= day } ]
      end
      visitor_retention_total = @visitor_retention.first[1]
      @visitor_retention.each_with_index do |day, index|
        day[0] = "#{day[0]} (#{day[1]})"
        day[1] = (day[1].to_f / visitor_retention_total * 100).round(2)
      end
    end

    @events_created_by_source = Event
      .joins(:city_source)
      .joins(:source)
      .group(sources: :name)
      .order(sources: { name: :asc })
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count
    @events_created_by_city = Event
      .joins(:city_source)
      .joins(:city)
      .group(cities: :name)
      .order(cities: { name: :asc })
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count
    @city_scores = City.enabled
      .sort_by(&:current_score)
      .reverse
      .map { |city| [ "#{city.name} (#{city.current_score})", city.current_score ] }
  end

  private

  def load_filters
    @time_interval = params[:time_interval].present? ?
      params[:time_interval] :
      TIME_INTERVAL

    @start_date = params[:start_date].present? ?
      Date.parse(params[:start_date]) :
      START_DATE

    @end_date = params[:end_date].present? ?
      Date.parse(params[:end_date]) :
      Date.today

    @time_range = @start_date.beginning_of_day..@end_date.end_of_day
  end

  def build_ahoy_events_page_events_data(event_name)
    Ahoy::Event
      .joins(:visit)
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: event_name)
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count("DISTINCT ahoy_visits.visitor_token")
  end

  def ordinal_suffix(day)
    case day
    when 1 then "st"
    when 2 then "nd"
    when 3 then "rd"
    else "th"
    end
  end
end
