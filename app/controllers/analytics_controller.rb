class AnalyticsController < ApplicationController
  START_DATE = 4.weeks.ago.end_of_week + 1.day

  before_action :require_admin!

  def index
    start_date = params[:start_date].present? ?
      Date.parse(params[:start_date]) :
      START_DATE

    @visits = Ahoy::Visit
      .where(user_id: nil)
      .group_by_week(:started_at, range: start_date..)
      .count
    @visits_by_device = Ahoy::Visit
      .where(user_id: nil)
      .group(:device_type)
      .group_by_week(:started_at, range: start_date..)
      .count
    @visits_by_referring_domain = Ahoy::Visit
      .where(user_id: nil)
      .group(:referring_domain)
      .group_by_week(:started_at, range: start_date..)
      .count
    @sign_up_page_events = build_ahoy_events_page_events_data(
      "Visited sign up page",
      start_date: start_date
    )
    @pricing_page_events = build_ahoy_events_page_events_data(
      "Visited pricing page",
      start_date: start_date
    )

    @city_views = build_ahoy_events_popularity_data(
      "properties->>'city'",
      label_format: ->(city) { city },
      start_date: start_date
    )
    @time_period_views = build_ahoy_events_popularity_data(
      "properties->>'time_period'",
      label_format: ->(period) { period },
      start_date: start_date
    )
    @city_time_period_views = build_ahoy_events_popularity_data(
      [ "properties->>'city'", "properties->>'time_period'" ],
      label_format: ->(city, period) { "#{city} - #{period}" },
      start_date: start_date
    )

    @seens = Seen
      .left_joins(:user)
      .where(user: { id: nil })
      .group_by_week(:created_at, range: start_date..)
      .count

    @sign_up_page_cities = Ahoy::Event
      .left_joins(:user)
      .joins("INNER JOIN cities ON cities.id = (ahoy_events.properties->'params'->>'city_id')::integer")
      .where(user: { id: nil })
      .where(name: "Visited sign up page")
      .where("properties->'params'->>'city_id' IS NOT NULL")
      .where("ahoy_events.time >= ?", start_date)
      .group("cities.name")
      .count
    @sign_up_page_queries = Ahoy::Event
      .left_joins(:user)
      .where(user: { id: nil })
      .where(name: "Visited sign up page")
      .where("properties->'params'->>'query' IS NOT NULL")
      .where("ahoy_events.time >= ?", start_date)
      .group("properties->'params'->>'query'")
      .count

    @events = Event
      .joins(:city_source)
      .joins(:city)
      .group("cities.name")
      .group_by_week(:created_at, range: start_date..)
      .count
    @aggregated_users = User
      .group_by_week(:created_at, range: start_date..)
      .count
      .transform_values { |v| v }
      .transform_keys { |k| k.to_date }
      .sort
      .each_with_object({}) { |(date, count), hash|
        hash[date] = (hash.values.last || 0) + count
      }
    @search_queries = SearchQuery
      .group_by_week(:created_at, range: start_date..)
      .count
      .transform_values { |v| v }
      .transform_keys { |k| k.to_date }
      .sort
  end

  private

  def build_ahoy_events_page_events_data(event_name, start_date:)
    Ahoy::Event
      .left_joins(:user)
      .where(user: { id: nil })
      .where(name: event_name)
      .group_by_week(:time, range: start_date..)
      .count
  end

  def build_ahoy_events_popularity_data(group_by_columns, label_format: nil, start_date:)
    label_format ||= ->(*values) { values.first }

    Ahoy::Event
      .left_joins(:user)
      .where(user: { id: nil })
      .where(name: "Viewed events")
      .group(*Array(group_by_columns))
      .group_by_week(:time, range: start_date..)
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
