module Marketing::Events::Ordering
  def order_events
    if @sort_by == "popularity"
      order_events_by_popularity
    else
      order_events_by_time
    end
  end

  def order_events_by_popularity
    @events = @events.order(
      Event.arel_table[:seens_count].desc,
      Event.arel_table[:attendees_count].desc.nulls_last,
      start_date: :asc,
      start_time: :asc,
    )
  end

  def order_events_by_time
    @events = @events.order(:start_date, :start_time)
  end
end
