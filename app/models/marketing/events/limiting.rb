module Marketing::Events::Limiting
  LIMIT = 50

  def limit_events
    @events = @events.limit(LIMIT)
  end

  private

  def limit
    LIMIT
  end
end
