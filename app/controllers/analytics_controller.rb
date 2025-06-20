class AnalyticsController < AdminController
  START_DATE = (4.weeks.ago.end_of_week + 1.day).to_date
  TIME_INTERVAL = "day"

  before_action :load_filters

  def index
    @city_active_user_scores = City.enabled
      .sort_by(&:active_user_score)
      .reverse
      .map { |city| [ "#{city.name} (#{city.active_user_score})", city.active_user_score ] }
    @city_visitor_scores = City.enabled
      .sort_by(&:visitor_score)
      .reverse
      .map { |city| [ "#{city.name} (#{city.visitor_score})", city.visitor_score ] }

    @visitors = Ahoy::Visit
      .legitimate
      .non_admin
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count("DISTINCT visitor_token")
    @search_engine_visitors = Ahoy::Visit
      .legitimate
      .non_admin
      .where("referrer LIKE '%google%' OR referrer LIKE '%bing%' OR referrer LIKE '%yandex%' OR referrer LIKE '%yahoo%' OR referrer LIKE '%duckduckgo%' OR referrer LIKE '%baidu%'")
      .group(:referrer)
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count("DISTINCT visitor_token")
    @bounces = Ahoy::Visit
      .legitimate
      .non_admin
      .where.not(duration: nil)
      .where("duration < 10")
      .group(:duration)
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count
      .transform_keys { |key| [ "#{key[0]}s", key[1] ] }
    @bounces_by_search_engine = Ahoy::Visit
      .legitimate
      .non_admin
      .where("referrer LIKE '%google%' OR referrer LIKE '%bing%' OR referrer LIKE '%yandex%' OR referrer LIKE '%yahoo%' OR referrer LIKE '%duckduckgo%' OR referrer LIKE '%baidu%'")
      .where.not(duration: nil)
      .where("duration < 10")
      .group(:referrer)
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count
    @visits_by_device = Ahoy::Visit
      .legitimate
      .non_admin
      .where.not(device_type: nil)
      .group(:device_type)
      .where(started_at: @time_range)
      .count
      .sort_by { |(_, count)| count }
      .reverse
    @visits_by_os = Ahoy::Visit
      .legitimate
      .non_admin
      .where.not(os: nil)
      .group(:os)
      .where(started_at: @time_range)
      .count
      .sort_by { |(_, count)| count }
      .reverse
    @visits_by_browser = Ahoy::Visit
      .legitimate
      .non_admin
      .where.not(browser: nil)
      .group(:browser)
      .where(started_at: @time_range)
      .count
      .sort_by { |(_, count)| count }
      .reverse
    @visits_by_referring_domain = Ahoy::Visit
      .legitimate
      .non_admin
      .where.not(referring_domain: nil)
      .group(:referring_domain)
      .where(started_at: @time_range)
      .count
      .sort_by { |(_, count)| count }
      .reverse
    @pricing_page_events = build_ahoy_events_page_events_data("Visited pricing page")
    @city_events_page_events = build_ahoy_events_page_events_data("Viewed events")
    @event_category_city_events_page_events = Ahoy::Event
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: "Viewed events")
      .group("COALESCE(properties->>'event_category', 'events')")
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count
    @homepage_events = build_ahoy_events_page_events_data("Visited homepage")

    qualified_visitor_tokens_for_retention = Ahoy::Visit
      .group(:visitor_token)
      .minimum(:started_at)
      .select { |_, started_at| (started_at + 1.send(@time_interval.to_sym)).past? }
      .map { |visitor_token, _| visitor_token }

    @visitor_retention = []
    visits_h = Ahoy::Visit
      .legitimate
      .non_admin
      .where(started_at: @time_range)
      .where(visitor_token: qualified_visitor_tokens_for_retention)
      .group(:visitor_token)
      .count("DISTINCT DATE_TRUNC('#{@time_interval.upcase}', started_at)")
    visit_counts = visits_h.values
    if visit_counts.present?
      (visit_counts.min..visit_counts.max).each do |day|
        @visitor_retention << [ "#{day}#{ordinal_suffix(day)}", visit_counts.count { |count| count >= day } ]
      end
      @visitor_retention_total = @visitor_retention.first[1]
      @visitor_retention.each_with_index do |day, index|
        day[0] = "#{day[0]} (#{day[1]})"
        day[1] = (day[1].to_f / @visitor_retention_total * 100).round(2)
      end
    end

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

    hour_views_h = Ahoy::Event
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .joins("INNER JOIN cities ON cities.name = ahoy_events.properties->>'city'")
      .where(name: "Viewed events")
      .where(time: @time_range)
      .group(Arel.sql("EXTRACT(HOUR FROM ahoy_events.time AT TIME ZONE 'UTC' AT TIME ZONE cities.time_zone)"))
      .count
      .transform_keys { |hour| hour.to_i }
    @hour_views = (0..23)
      .map { |hour| [ hour, hour_views_h[hour] || 0 ] }
      .sort_by { |(hour, _)| hour }

    @nearby_events_page_views = Ahoy::Event
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: "Viewed events")
      .where("(properties->>'nearby')::boolean IS TRUE")
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count
    @nearby_events_city_views = Ahoy::Event
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: "Viewed events")
      .where("(properties->>'nearby')::boolean IS TRUE")
      .where(time: @time_range)
      .group("properties->>'city'")
      .count
      .sort_by { |(_, count)| count }
      .reverse

    @viewed_event_by_source = Ahoy::Event
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: "Viewed event")
      .where(time: @time_range)
      .group("properties->>'source'")
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count
    @seens = Seen
      .where(seenable_type: [ nil, "Visitor" ])
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count

    @map_page_queries = Ahoy::Event
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: [ "Searched", "Searched on map" ])
      .where("properties->>'query' IS NOT NULL")
      .where(time: @time_range)
      .order(time: :desc)
      .pluck(:time, Arel.sql("properties->>'query'"))

    # Usage
    @aggregated_users = User
      .where.not(id: 1)
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count
      .transform_values { |v| v }
      .transform_keys { |k| k.to_date }
      .sort
      .each_with_object({}) { |(date, count), hash|
        hash[date] = (hash.values.last || 0) + count
      }
    @sign_ins = Ahoy::Visit
      .where.not(user_id: [ nil, 1 ])
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .distinct.count(:user_id)
      .transform_values { |v| v }
      .transform_keys { |k| k.to_date }
      .sort
    @map_page_events = build_ahoy_events_page_events_data("Visited map page")
    @bookmarks = Bookmark
      .where.not(user_id: 1)
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count
      .transform_values { |v| v }
      .transform_keys { |k| k.to_date }
      .sort
    @events_created = Event
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count
    @events_by_source = Event
      .joins(:city_source)
      .joins(:source)
      .group("sources.name")
      .order("sources.name ASC")
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count

    @days_between_first_and_second_visits = days_between_visits(second_is_last: false)
    @days_between_first_and_last_visits = days_between_visits(second_is_last: true)
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
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: event_name)
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count
  end

  def ordinal_suffix(day)
    case day
    when 1 then "st"
    when 2 then "nd"
    when 3 then "rd"
    else "th"
    end
  end

  def days_between_visits(second_is_last: false)
    visitors = Visitor
      .joins(:visits)
      .select("
        visitors.visitor_token,
        MIN(visits.started_at) as first_visit_at,
        (
          SELECT #{second_is_last ? "MAX" : "MIN"}(v2.started_at)
          FROM ahoy_visits v2
          WHERE v2.visitor_token = visitors.visitor_token
          AND v2.started_at > MIN(visits.started_at)
        ) as second_visit_at
      ")
      .where(visits: { id: Ahoy::Visit.legitimate.non_admin.pluck(:id) })
      .group("visitors.visitor_token")
      .having("COUNT(visits.id) >= 2")

    # Calculate days between visits
    days_between = visitors.map { |visitor| (visitor.second_visit_at.to_date - visitor.first_visit_at.to_date).to_i }

    # Create distribution hash with all days in range
    min_day = days_between.min || 0
    max_day = days_between.max || 0

    # Initialize hash with all days in range set to 0
    distribution = (min_day..max_day).each_with_object({}) do |day, hash|
      hash[day] = 0
    end

    # Add actual counts
    days_between.each do |days|
      distribution[days] += 1
    end

    distribution
  end
end
