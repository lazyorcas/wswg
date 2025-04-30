class FindAndCreateEventsJob < ApplicationJob
  HOUR_TO_FETCH_EVENTS = 6
  ACTIVE_USER_VISIT_WINDOW = 1.week
  POPULAR_CITY_MIN_USER_COUNT = 10

  queue_with_priority 2

  def perform
    TimeZone.includes(cities: :city_sources).find_each do |time_zone|
      next if time_zone.now.hour != HOUR_TO_FETCH_EVENTS

      time_zone.cities.each do |city|
        city_score = calculate_city_score(city)
        next if city_score.zero?

        city.city_sources.find_each do |city_source|
          CitySource::FindAndCreateEventsJob.perform_later(
            city_source.id,
            page_count_modifier: city_score
          )
        end
      end
    end
  end

  private

  def calculate_city_score(city)
    Math.min(1, get_active_user_count(city) / POPULAR_CITY_MIN_USER_COUNT.to_f)
  end

  def get_active_user_count(city)
    city.users
      .joins(:visits)
      .where(visits: { started_at: ACTIVE_USER_VISIT_WINDOW.ago.. })
      .count
  end
end
