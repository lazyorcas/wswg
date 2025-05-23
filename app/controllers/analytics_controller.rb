class AnalyticsController < ApplicationController
  START_DATE = 4.weeks.ago.end_of_week + 1.day
  TIME_INTERVAL = "day"

  before_action :require_admin!
  before_action :load_filters

  def index
    @visits = Ahoy::Visit
      .non_user
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count
    @visits_by_device = Ahoy::Visit
      .non_user
      .where.not(device_type: nil)
      .group(:device_type)
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count
    @visits_by_referring_domain = Ahoy::Visit
      .non_user
      .where.not(referring_domain: nil)
      .group(:referring_domain)
      .group_by_period(@time_interval, :started_at, range: @time_range, expand_range: true)
      .count
    @sign_up_page_events = build_ahoy_events_page_events_data("Visited sign up page")
    @pricing_page_events = build_ahoy_events_page_events_data("Visited pricing page")
    @city_events_page_events = build_ahoy_events_page_events_data("Viewed events")
    @homepage_events = build_ahoy_events_page_events_data("Visited homepage")

    @city_views = build_ahoy_events_popularity_data(
      "properties->>'city'",
      label_format: ->(city) { city },
    )
    @time_period_views = build_ahoy_events_popularity_data(
      "properties->>'time_period'",
      label_format: ->(period) { period },
    )
    @wday_views = Ahoy::Event
      .non_user
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
            day = Date::DAYNAMES[(dow.to_i + 6) % 7]
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
    @city_time_period_views = build_ahoy_events_popularity_data(
      [ "properties->>'city'", "properties->>'time_period'" ],
      label_format: ->(city, period) { "#{city} - #{period}" },
    )

    @seens = Seen
      .where(user_id: nil)
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count

    @sign_up_page_cities = Ahoy::Event
      .non_user
      .joins("INNER JOIN cities ON cities.id = (ahoy_events.properties->'params'->>'city_id')::integer")
      .where(name: "Visited sign up page")
      .where("properties->'params'->>'city_id' IS NOT NULL")
      .where("ahoy_events.time >= ?", @start_date)
      .group("cities.name")
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count
    @sign_up_page_queries = Ahoy::Event
      .non_user
      .where(name: "Visited sign up page")
      .where("properties->'params'->>'query' IS NOT NULL")
      .where("ahoy_events.time >= ?", @start_date)
      .group("properties->'params'->>'query'")
      .count
    @sign_up_page_bookmarks = Ahoy::Event
      .non_user
      .where(name: "Visited sign up page")
      .where("properties->'params'->>'bookmark_event_id' IS NOT NULL")
      .where("ahoy_events.time >= ?", @start_date)
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count

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
    @search_queries = SearchQuery
      .where.not(user_id: 1)
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count
      .transform_values { |v| v }
      .transform_keys { |k| k.to_date }
      .sort
    @bookmarks = Bookmark
      .where.not(user_id: 1)
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count
      .transform_values { |v| v }
      .transform_keys { |k| k.to_date }
      .sort
    @events_by_city = Event
      .joins(:city_source)
      .joins(:city)
      .group("cities.name")
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count
    @events_by_source = Event
      .joins(:city_source)
      .joins(:source)
      .group("source.name")
      .group_by_period(@time_interval, :created_at, range: @time_range, expand_range: true)
      .count
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
      Date.parse(params[:end_date]).end_of_day :
      Time.now

    @time_range = @start_date..@end_date
  end

  def build_ahoy_events_page_events_data(event_name)
    Ahoy::Event
      .non_user
      .where(name: event_name)
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count
  end

  def build_ahoy_events_popularity_data(group_by_columns, label_format: nil)
    label_format ||= ->(*values) { values.first }

    Ahoy::Event
      .non_user
      .where(name: "Viewed events")
      .group(*Array(group_by_columns))
      .group_by_period(@time_interval, :time, range: @time_range, expand_range: true)
      .count
      .group_by { |values, _| label_format.call(*values[0...-1]) }
      .map { |label, data|
        {
          name: label,
          data: data.each_with_object({}) { |((*_, date), count), hash| hash[date.to_date] = count }
        }
      }
  end
end
