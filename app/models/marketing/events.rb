module Marketing::Events
  def load_events
    @events = Event.all
    build_events_query
    @events
  end

  def build_events_query
    raise NotImplementedError
  end
end
