module City::Scorable
  extend ActiveSupport::Concern

  TIME_WINDOW = 2.weeks
  POPULAR_CITY_MIN_VISITOR_COUNT = 50

  def current_score
    @current_score ||= visitor_score
  end

  def visitor_score
    @visitor_score ||= (1.0 * visitor_count / POPULAR_CITY_MIN_VISITOR_COUNT).round(2)
  end

  def visitor_count
    @visitor_count ||= Ahoy::Event
      .joins(:visit)
      .where(visit: { analyzable: true })
      .where(name: [ "Viewed events", "Visited map page" ], time: TIME_WINDOW.ago..)
      .where("properties->>'city' = ?", self.name)
      .where("referrer_host IS NULL OR referrer_host != ?", "google_ads")
      .count("DISTINCT (CASE WHEN ahoy_visits.user_id IS NOT NULL THEN ahoy_visits.user_id::text ELSE ahoy_visits.visitor_token END)")
  end
end
