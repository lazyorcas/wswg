module SearchQuery::Broadcastable
  include Turbo::Broadcastable
  include Broadcastable

  def broadcast_completed
    broadcast_update_to(
      self,
      target: "search-results",
      partial: "search_queries/events",
      locals: {
        events: result_things,
        took_in_seconds: took_in_seconds,
        viewing_user: user
      }
    )
  end
end
