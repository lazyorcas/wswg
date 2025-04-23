class SearchQuery::PollForSearchesJob < ApplicationJob
  MAX_ATTEMPTS = 5
  WAIT_DURATION = 2.seconds

  queue_with_priority 1

  def perform(id, attempt: 1)
    return if attempt > MAX_ATTEMPTS

    search_query = SearchQuery.find(id)

    if search_query.done_searching?
      search_query.broadcast_completed
      search_query.completed!
    else
      SearchQuery::PollForSearchesJob
        .set(wait: WAIT_DURATION)
        .perform_later(id, attempt: attempt + 1)
    end
  end
end
