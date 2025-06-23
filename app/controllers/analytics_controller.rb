class AnalyticsController < AdminController
  START_DATE = (4.weeks.ago.end_of_week + 1.day).to_date
  TIME_INTERVAL = "day"
  ACTIVATION_EVENT_NAMES = [ "Viewed event", "Searched", "Visited map page", "Searched on map" ].freeze

  before_action :load_filters
  before_action :load_visitor_tokens
  before_action :load_top_referrer_hosts

  def index
    # Market
    @wday_views = Ahoy::Event
      .where(visit: Ahoy::Visit.where(visitor_token: @visitor_tokens))
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
    @search_queries = Ahoy::Event
      .where(visit: Ahoy::Visit.where(visitor_token: @visitor_tokens))
      .where(name: [ "Searched", "Searched on map" ])
      .where("properties->>'query' IS NOT NULL")
      .where(time: @time_range)
      .order(time: :desc)
      .pluck(:time, Arel.sql("properties->>'query'"))

    # Journey
    @journeys = Ahoy::Visit
      .where(visitor_token: @visitor_tokens)
      .where(started_at: @time_range)
      .limit(100)
      .includes(:user, :events)
      .sort_by { |visit| visit.started_at }
      .reverse
      .map do |visit|
        {
          started_at: visit.started_at,
          origin: visit.user_id.present? ? visit.user.email : visit.referrer_host || "direct",
          events: visit.events.map(&:name).join(" → ")
        }
      end

    # Acquisition
    @visitors = Ahoy::Visit
      .where(visitor_token: @visitor_tokens)
      .where(referrer_host: @top_referrer_hosts)
      .group(:referrer_host)
      .order(:referrer_host)
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count("DISTINCT (CASE WHEN user_id IS NOT NULL THEN user_id::text ELSE visitor_token END)")
      .transform_keys { |key| [ key[0].present? ? key[0] : "direct", key[1] ] }
    @homepage_views = Ahoy::Event
      .joins(:visit)
      .where(visit: Ahoy::Visit.where(visitor_token: @visitor_tokens))
      .where(name: "Visited homepage")
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count("DISTINCT (CASE WHEN ahoy_visits.user_id IS NOT NULL THEN ahoy_visits.user_id::text ELSE ahoy_visits.visitor_token END)")
    @events_page_views = Ahoy::Event
      .joins(:visit)
      .where(visit: Ahoy::Visit.where(visitor_token: @visitor_tokens))
      .where(name: "Viewed events")
      .group("(CASE WHEN properties->>'nearby' = 'true' THEN 'nearby ' ELSE '' END) || COALESCE(properties->>'event_category', 'events')")
      .order(Arel.sql("(CASE WHEN properties->>'nearby' = 'true' THEN 'nearby ' ELSE '' END) || COALESCE(properties->>'event_category', 'events')"))
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count("DISTINCT (CASE WHEN ahoy_visits.user_id IS NOT NULL THEN ahoy_visits.user_id::text ELSE ahoy_visits.visitor_token END)")
    @pricing_page_events = build_ahoy_events_page_events_data("Visited pricing page")

    # Activation
    @activation = Ahoy::Event
      .joins(:visit)
      .where(visit: Ahoy::Visit.where(visitor_token: @visitor_tokens))
      .where(name: ACTIVATION_EVENT_NAMES)
      .where(time: @time_range)
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count("DISTINCT (CASE WHEN ahoy_visits.user_id IS NOT NULL THEN ahoy_visits.user_id::text ELSE ahoy_visits.visitor_token END)")
    @activation_by_event = Ahoy::Event
      .joins(:visit)
      .where(visit: Ahoy::Visit.where(visitor_token: @visitor_tokens))
      .where(name: ACTIVATION_EVENT_NAMES)
      .where(time: @time_range)
      .group(:name)
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count("DISTINCT (CASE WHEN ahoy_visits.user_id IS NOT NULL THEN ahoy_visits.user_id::text ELSE ahoy_visits.visitor_token END)")
    @bounces_by_landing_page = Ahoy::Visit
      .where(visitor_token: @visitor_tokens)
      .where(referrer_host: @top_referrer_hosts)
      .where("duration < ?", Ahoy::Visit::BOUNCE_DURATION)
      .group(:landing_page)
      .order(:landing_page)
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count("DISTINCT (CASE WHEN user_id IS NOT NULL THEN user_id::text ELSE visitor_token END)")
      .transform_keys { |landing_page, started_at| [ URI.parse(landing_page).path, started_at ] }
    @bounces_by_duration = Ahoy::Visit
      .where(visitor_token: @visitor_tokens)
      .where(referrer_host: @top_referrer_hosts)
      .where("duration < ?", Ahoy::Visit::BOUNCE_DURATION)
      .group(:duration)
      .order(:duration)
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count("DISTINCT (CASE WHEN user_id IS NOT NULL THEN user_id::text ELSE visitor_token END)")
      .transform_keys { |key| [ "#{key[0]}s", key[1] ] }

    @viewed_event_events_by_source = Ahoy::Event
      .where(visit: Ahoy::Visit.where(visitor_token: @visitor_tokens))
      .where(name: "Viewed event")
      .where(time: @time_range)
      .group("properties->>'source'")
      .order(Arel.sql("properties->>'source'"))
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count

    @retention_by_referrer_host = []
    first_visit_ids = Ahoy::Visit
      .where.missing(:user)
      .group(:visitor_token)
      .minimum(:id)
      .values
    first_referrer_host_to_visitor_tokens = Ahoy::Visit
      .where(id: first_visit_ids)
      .where(started_at: @time_range)
      .pluck(:referrer_host, :visitor_token)
      .group_by(&:first)
      .map { |referrer_host, arr| [ referrer_host, arr.map(&:last) ] }
      .to_h
    usage_visitor_tokens = Ahoy::Visit
      .joins(:events)
      .where("duration >= ? OR (referrer_host != ? AND name IN (?))", Ahoy::Visit::BOUNCE_DURATION, ENV["HOST_NAME"], ACTIVATION_EVENT_NAMES)
      .pluck(:visitor_token)
      .uniq
    first_user_visit_ids = Ahoy::Visit
      .non_admin
      .where.associated(:user)
      .group(:user_id)
      .minimum(:id)
      .values
    first_referrer_host_to_user_ids = Ahoy::Visit
      .where(id: first_user_visit_ids)
      .where(started_at: @time_range)
      .pluck(:referrer_host, :user_id)
      .group_by(&:first)
      .map { |referrer_host, arr| [ referrer_host, arr.map(&:last) ] }
      .to_h

    @top_referrer_hosts.each do |referrer_host|
      series = { name: referrer_host.present? ? referrer_host : "direct", data: [] }
      visit_counts = Ahoy::Visit
        .where(visitor_token: (first_referrer_host_to_visitor_tokens[referrer_host] & usage_visitor_tokens) || [])
        .or(Ahoy::Visit.where(user_id: first_referrer_host_to_user_ids[referrer_host] || []))
        .group("CASE WHEN user_id IS NOT NULL THEN user_id::text ELSE visitor_token END")
        .having("MIN(started_at) + INTERVAL '1 #{@time_interval.upcase}' < NOW()")
        .count("DISTINCT DATE_TRUNC('#{@time_interval.upcase}', started_at)")
        .values
      if visit_counts.present?
        (visit_counts.min..visit_counts.max).each do |day|
          series[:data] << [ "#{day}#{ordinal_suffix(day)} #{@time_interval}", visit_counts.count { |count| count >= day } ]
        end
        total = series[:data].first[1]
        series[:name] = "#{series[:name]} (#{total})"
        series[:data].each_with_index do |day, index|
          day[1] = (day[1].to_f / total * 100).round(2)
        end
      end
      @retention_by_referrer_host << series
    end
    @retention_by_referrer_host = @retention_by_referrer_host
      .sort_by { |series| [ series[:name] == "direct" ? 0 : 1, series[:name] ] }
      .reject { |series| series[:data].empty? }

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

  def load_top_referrer_hosts
    @top_referrer_hosts = Ahoy::Visit
      .legitimate
      .non_admin
      .group(:referrer_host)
      .count("DISTINCT (CASE WHEN user_id IS NOT NULL THEN user_id::text ELSE visitor_token END)")
      .reject { |_, count| count <= 1 }
      .sort_by { |_, count| count }
      .reverse
      .map(&:first)
  end

  def load_visitor_tokens
    @visitor_tokens = Ahoy::Visit
      .legitimate
      .non_admin
      .pluck(:visitor_token)
      .uniq
  end

  def build_ahoy_events_page_events_data(event_name)
    Ahoy::Event
      .joins(:visit)
      .where(visit: Ahoy::Visit.where(visitor_token: @visitor_tokens))
      .where(name: event_name)
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count("DISTINCT (CASE WHEN ahoy_visits.user_id IS NOT NULL THEN ahoy_visits.user_id::text ELSE ahoy_visits.visitor_token END)")
  end

  def ordinal_suffix(day)
    case day
    when 1 then "st"
    when 2 then "nd"
    when 3 then "rd"
    else "th"
    end
  end

  def extract_path_from_url(url)
    return nil if url.nil?
    uri = Addressable::URI.parse(url)
    uri.path
  end
end
