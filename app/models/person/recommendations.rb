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

      event_scope = if city.persisted?
        Event
          .joins(:city_source)
          .where(city_sources: { city_id: city.id })
          .where("events.start_date_time >= ?", current_date_time)
      else
        Event
          .joins(:location)
          .within(Event::Locatable::MAX_DISTANCE_TO_CITY, origin: city.coordinates_arr)
      end

      event_ids = []

      interest_set.weighted_keywords.each do |keyword|
        break if event_ids.size >= LIMIT

        tsquery = keyword.gsub(" ", " | ")

        event_ids += event_scope
          .select(:id, "ts_rank(events.extended_keywords, plainto_tsquery('#{tsquery}')) AS rank")
          .joins("JOIN interest_sets ON interest_sets.interestable_id = #{id} AND interest_sets.interestable_type = '#{self.class.name}' AND events.extended_keywords @@ plainto_tsquery('#{tsquery}')")
          .order("rank DESC")
          .limit(LIMIT - event_ids.size)
          .to_a
          .map(&:id)
      end

      event_ids.uniq
    end
  end

  def create_or_update_interest_set!
    weighted_keywords = build_weighted_keywords

    if interest_set.present?
      interest_set.update!(weighted_keywords: weighted_keywords)
    else
      InterestSet.create!(interestable: self, weighted_keywords: weighted_keywords)
    end
  end
end
