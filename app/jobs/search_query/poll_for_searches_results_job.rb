class SearchQuery::PollForSearchesResultsJob < ApplicationJob
  MAX_ATTEMPTS = 10
  SLEEP_TIME = 1

  queue_with_priority 0

  def perform(id)
    search_query = SearchQuery.find(id)

    MAX_ATTEMPTS.times do
      break if search_query.complete?
      sleep SLEEP_TIME
    end

    search_query.complete!
  end
end
