module City::Scorable
  extend ActiveSupport::Concern

  TIME_WINDOW = 1.week
  POPULAR_CITY_MIN_VISITOR_COUNT = 100

  def current_score
    @current_score ||= visitor_score
  end

  def visitor_score
    @visitor_score ||= (visitor_count / POPULAR_CITY_MIN_VISITOR_COUNT).round(2)
  end

  def visitor_count
    @visitor_count ||= Ahoy::Event
      .joins(:visit)
      .where(visit: Ahoy::Visit.legitimate.non_admin)
      .where(name: "Viewed events", time: TIME_WINDOW.ago..)
      .where("properties->>'city' = ?", self.name)
      .count("DISTINCT ahoy_visits.visitor_token")
  end
end
