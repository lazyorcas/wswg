class FindAndCreateEventsJob < ApplicationJob
  HOUR_TO_FETCH_EVENTS = 6
  ACTIVE_USER_VISIT_WINDOW = 1.week
  POPULAR_CITY_MIN_USER_COUNT = 10

  queue_with_priority 2

  def perform
    TimeZone.includes(city_sources: :city).find_each do |time_zone|
      next if time_zone.now.hour != HOUR_TO_FETCH_EVENTS

      time_zone.city_sources.find_each do |city_source|
        CitySource::FindAndCreateEventsJob.perform_later(city_source.id)
      end
    end
  end

  private

  def calculate_popular_city_coefficient(city)
    Math.min(1, get_active_user_count(city) / POPULAR_CITY_MIN_USER_COUNT.to_f)
  end

  def get_active_user_count(city)
    city.users
      .joins(:visits)
      .where(visits: { started_at: ACTIVE_USER_VISIT_WINDOW.ago.. })
      .count
  end
end
