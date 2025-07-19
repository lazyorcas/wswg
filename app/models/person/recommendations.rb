module Person::Recommendations
  extend ActiveSupport::Concern
  include Keywords

  LIMIT = 1000

  included do
    has_one :interest_set, as: :interestable
  end

  def recommendable_events(city)
    ids = recommendable_event_ids(city)
    Event.where(id: ids).in_order_of(:id, ids)
  end

  def recommendable_event_ids(city)
    @recommendable_event_ids ||= begin
      current_date_time = city.time_zone.current_date_time

      events = if city.persisted?
        Event
          .joins(:city_source)
          .where(city_sources: { city_id: city.id })
          .where("events.start_date_time >= ?", current_date_time)
      else
        Event
          .joins(:location)
          .within(Event::Locatable::MAX_DISTANCE_TO_CITY, origin: city.coordinates_arr)
      end

      events
        .select(:id, "ts_rank(interest_sets.keywords, plainto_tsquery(events.title)) AS rank")
        .joins("JOIN interest_sets ON interest_sets.interestable_id = #{id} AND interest_sets.interestable_type = '#{self.class.name}' AND interest_sets.keywords @@ plainto_tsquery(events.title)")
        .order("rank DESC")
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

  # TODO: consider bookmarks, search queries
  def build_keywords
    # WARNING: cannot use .first because it triggers ORDER
    seen_events.select("tsvector_agg(keywords) AS keywords")[0].keywords
  end
end
