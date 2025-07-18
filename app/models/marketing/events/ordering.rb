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
      seens_count: :desc,
      start_date: :asc,
      start_time: :asc,
      attendees_count: :desc
    )
  end

  def order_events_by_time
    @events = @events.order(:start_date, :start_time)
  end
end
