module City::Scorable
  extend ActiveSupport::Concern

  TIME_WINDOW = 1.week
  POPULAR_CITY_MIN_USER_COUNT = 10
  POPULAR_CITY_MIN_VISITOR_COUNT = 250

  def current_score
    active_user_score + visitor_score
  end

  def active_user_score
    (1.0 * active_user_count / POPULAR_CITY_MIN_USER_COUNT).round(2)
  end

  def visitor_score
    (1.0 * visitor_count / POPULAR_CITY_MIN_VISITOR_COUNT).round(2)
  end

  def active_user_count
    users
      .joins(:visits)
      .where(visits: { started_at: TIME_WINDOW.ago.. })
      .count
  end

  def visitor_count
    Ahoy::Event
      .non_user
      .joins(:visit)
      .where(name: "Viewed events", time: TIME_WINDOW.ago..)
      .where("properties->>'city' = ?", self.name)
      .count("DISTINCT ahoy_visits.visitor_token")
  end
end
