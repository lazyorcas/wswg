module City::Scorable
  extend ActiveSupport::Concern

  POPULAR_CITY_MIN_USER_COUNT = 10
  ACTIVE_USER_VISIT_TIME_WINDOW = 2.weeks

  POPULAR_CITY_MIN_VISIT_COUNT = 500
  ACTIVE_VISIT_TIME_WINDOW = 1.week

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
      .where(visits: { started_at: ACTIVE_USER_VISIT_TIME_WINDOW.ago.. })
      .count
  end

  def visit_count
    Ahoy::Visit
      .non_user
      .where(city: self.name, started_at: ACTIVE_VISIT_TIME_WINDOW.ago..)
      .count
  end
end
