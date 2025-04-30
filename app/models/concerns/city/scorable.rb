module City::Scorable
  extend ActiveSupport::Concern

  MAX_SCORE = 1
  POPULAR_CITY_MIN_USER_COUNT = 10
  ACTIVE_USER_VISIT_TIME_WINDOW = 1.week

  def current_score
    Math.min(MAX_SCORE, active_user_count / POPULAR_CITY_MIN_USER_COUNT.to_f)
  end

  def active_user_count
    users
      .joins(:visits)
      .where(visits: { started_at: ACTIVE_USER_VISIT_TIME_WINDOW.ago.. })
      .count
  end
end
