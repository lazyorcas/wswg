module Marketing::Events::Recommendations
  def filter_events_by_recommendations
    @events = @events.where(id: recommendable_event_ids)
  end

  def order_events_by_recommendations_ranks
    @events = @events.in_order_of(:id, recommendable_event_ids)
  end

  private

  def recommendable_event_ids
    @recommendable_event_ids ||= @person.recommendable_event_ids(@city)
  end
end
