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
        searcher: searcher
      }
    )
  end

  private

  def should_broadcast?
    !searcher.search_queries.excluding(self).exists?(created_at: created_at..)
  end

  def broadcast_exception(exception)
    message = exception.is_a?(UserReadableError) ? exception.message : "Failed to search. Try again."

    broadcast_error([ searcher, :flash ], message)
    broadcast_update_to(self, target: "search-results", html: "")
  end
end
