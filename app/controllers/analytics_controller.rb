class AnalyticsController < ApplicationController
  INTERVAL = 4.weeks

  before_action :require_admin!

  def index
    @visits = Ahoy::Visit
      .where(user_id: nil)
      .group_by_day(:started_at, range: INTERVAL.ago..)
      .count
    @sign_up_page_events = build_ahoy_events_page_events_data("Visited sign up page")
    @pricing_page_events = build_ahoy_events_page_events_data("Visited pricing page")

    @city_views = build_ahoy_events_popularity_data(
      "properties->>'city'",
      label_format: ->(city) { city }
    )
    @time_period_views = build_ahoy_events_popularity_data(
      "properties->>'time_period'",
      label_format: ->(period) { period }
    )
    @city_time_period_views = build_ahoy_events_popularity_data(
      [ "properties->>'city'", "properties->>'time_period'" ],
      label_format: ->(city, period) { "#{city} - #{period}" }
    )

    @seens = Seen
      .left_joins(:user)
      .where(user: { id: nil })
      .group_by_day(:created_at, range: INTERVAL.ago..)
      .count

    @sign_up_page_cities = Ahoy::Event
      .left_joins(:user)
      .joins("INNER JOIN cities ON cities.id = (ahoy_events.properties->'params'->>'city_id')::integer")
      .where(user: { id: nil })
      .where(name: "Visited sign up page")
      .where("properties->'params'->>'city_id' IS NOT NULL")
      .group("cities.name")
      .count
    @sign_up_page_queries = Ahoy::Event
      .left_joins(:user)
      .where(user: { id: nil })
      .where(name: "Visited sign up page")
      .where("properties->'params'->>'query' IS NOT NULL")
      .group_by { |event| event.properties["params"]["query"] }
      .count

    @aggregated_users = User
      .group_by_day(:created_at, range: INTERVAL.ago..)
      .count
      .transform_values { |v| v }
      .transform_keys { |k| k.to_date }
      .sort
      .each_with_object({}) { |(date, count), hash|
        hash[date] = (hash.values.last || 0) + count
      }
    @search_queries = SearchQuery
      .group_by_day(:created_at, range: INTERVAL.ago..)
      .count
      .transform_values { |v| v }
      .transform_keys { |k| k.to_date }
      .sort
  end

  private

  def build_ahoy_events_page_events_data(event_name)
    Ahoy::Event
      .left_joins(:user)
      .where(user: { id: nil })
      .where(name: event_name)
      .group_by_day(:time, range: INTERVAL.ago..)
      .count
  end

  def build_ahoy_events_popularity_data(group_by_columns, label_format: nil)
    label_format ||= ->(*values) { values.first }

    Ahoy::Event
      .left_joins(:user)
      .where(user: { id: nil })
      .where(name: "Viewed events")
      .group(*Array(group_by_columns))
      .group_by_day(:time, range: INTERVAL.ago..)
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
