module Marketing::Events::Ordering
  def order_events
    if @order_by == "popularity"
      order_events_by_popularity
    else
      order_events_by_time
    end
  end

  def order_events_by_popularity
    @events = @events.order(
      attendees_count: :desc,
      seens_count: :desc,
      start_date: :asc,
      start_time: :asc
    )
  end

  def order_events_by_time
    @events = @events.order(:start_date, :start_time)
  end
end
