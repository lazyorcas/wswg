module Person::Recommendations
  extend ActiveSupport::Concern

  LIMIT = 1000

  included do
    has_one :interest_set, as: :interestable
  end

  def recommendable_event_ids(city)
    @recommendable_event_ids ||= begin
      current_date_time = city.time_zone.current_date_time

      Event
        .select(:id, "ts_rank(interest_sets.keywords, plainto_tsquery(events.title)) AS rank")
        .joins("JOIN interest_sets ON interest_sets.interestable_id = #{id} AND interest_sets.interestable_type = '#{self.class.name}' AND interest_sets.keywords @@ plainto_tsquery(events.title)")
        .where("events.start_date_time >= ?", current_date_time)
        .order("rank DESC NULLS LAST")
        .limit(LIMIT)
        .to_a
        .map(&:id)
    end
  end

  def create_or_update_interest_set!
    if interest_set.present?
      interest_set.update!(keywords: build_keywords)
    else
      InterestSet.create!(interestable: self, keywords: build_keywords)
    end
  end

  def build_keywords
    # WARNING: cannot use .first because it triggers ORDER
    seen_events.select("tsvector_agg(keywords) AS keywords")[0].keywords
  end
end
