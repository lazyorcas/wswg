class SearchQuery::QueryJob < ApplicationJob
  queue_as :user

  def perform(id)
    search_query = SearchQuery.find(id)
    search_query.query!
  end
end
