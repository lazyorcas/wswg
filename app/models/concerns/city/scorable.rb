module City::Scorable
  extend ActiveSupport::Concern

  TIME_WINDOW = 1.week
  POPULAR_CITY_MIN_USER_COUNT = 10
  POPULAR_CITY_MIN_VISIT_COUNT = 100

  def current_score
    active_user_score + visit_score
  end

  def active_user_score
    (1.0 * active_user_count / POPULAR_CITY_MIN_USER_COUNT).round(2)
  end

  def visit_score
    (1.0 * visit_count / POPULAR_CITY_MIN_VISIT_COUNT).round(2)
  end

  def active_user_count
    users
      .joins(:visits)
      .where(visits: { started_at: TIME_WINDOW.ago.. })
      .count
  end

  def visit_count
    Ahoy::Event
      .non_user
      .where(name: "Viewed events", properties: { city: self.name })
      .where(time: TIME_WINDOW.ago..)
      .count("DISTINCT visit_id")
  end
end
