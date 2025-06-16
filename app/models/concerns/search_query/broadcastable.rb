module SearchQuery::Broadcastable
  extend ActiveSupport::Concern

  include Turbo::Broadcastable
  include Broadcastable

  included do
    with_options if: :should_broadcast?, on: :update do
      after_commit :broadcast_status, if: -> { status_previously_changed?(to: :searching) }
      after_commit :broadcast_result_events, if: -> { status_previously_changed?(to: :completed) }
    end
  end

  def broadcast_status
    broadcast_update_to(
      self,
      target: "search-results",
      partial: "map/search_queries/status",
      locals: {
        search_query: self
      }
    )
  end

  def broadcast_result_events
    broadcast_update_to(
      self,
      target: "search-results",
      partial: "map/search_queries/result",
      locals: {
        events: result.events,
        searcher: searcher,
        summary: summary
      }
    )
  end

  def can_broadcast?
    searcher.present?
  end

  def should_broadcast?
    can_broadcast?
  end

  def broadcast_exception(exception)
    broadcast_error([ searcher, :flash ], "Failed to search. Try again in a bit.")
    broadcast_update_to(self, target: "search-results", html: "")
  end
end
