module City::Scorable
  extend ActiveSupport::Concern

  POPULAR_CITY_MIN_USER_COUNT = 10
  ACTIVE_USER_VISIT_TIME_WINDOW = 2.weeks

  def current_score
    (1.0 * active_user_count / POPULAR_CITY_MIN_USER_COUNT).round(2)
  end

  def active_user_count
    users
      .joins(:visits)
      .where(visits: { started_at: ACTIVE_USER_VISIT_TIME_WINDOW.ago.. })
      .count
  end
end
