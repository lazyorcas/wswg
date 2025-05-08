class SearchQuery::QueryJob < ApplicationJob
  queue_with_priority 0

  def perform(id)
    search_query = SearchQuery.find(id)
    search_query.query!
  end
end
