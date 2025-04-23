class SearchQuery::CreateSearchesJob < ApplicationJob
  queue_with_priority 1

  def perform(id)
    search_query = SearchQuery.find(id)
    search_query.create_searches!

    SearchQuery::PollForSearchesJob
      .set(wait: 2.second)
      .perform_later(id)
  end
end
