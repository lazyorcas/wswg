module SearchQuery::Broadcastable
  extend ActiveSupport::Concern

  include Turbo::Broadcastable
  include Broadcastable

  included do
    after_commit :broadcast_result_events, if: -> { status_previously_changed?(to: :completed) && user.present? }
  end

  def broadcast_result_events
    broadcast_update_to(
      self,
      target: "search-results",
      partial: "map/search_queries/result",
      locals: {
        events: result.events,
        took_in_seconds: result.took_in_seconds,
        user: user
      }
    )
  end

  private

  def broadcast_exception(exception)
    message = exception.is_a?(UserReadableError) ? exception.message : "Failed to search. Try again."

    broadcast_error([ user, :flash ], message)
    broadcast_update_to(self, target: "search-results", html: "")
  end
end
