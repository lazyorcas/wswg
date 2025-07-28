module Business::EventQuery::Limitable
  extend ActiveSupport::Concern

  LIMIT = 200

  def limit_events
    @events = @events.limit(limit)
  end

  def limit
    LIMIT
  end
end
