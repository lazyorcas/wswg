module Search::Broadcastable
  include Turbo::Broadcastable
  include Broadcastable

  def broadcast_completed
    broadcast_update_to(
      self,
      target: "search-results",
      partial: "searches/#{model_type.underscore.pluralize}",
      locals: {
        events: result_items,
        took_in_seconds: result.took_in_seconds,
        viewing_user: user
      }
    )
  rescue
    broadcast_error("Failed to search. Try again.")
  end
end
