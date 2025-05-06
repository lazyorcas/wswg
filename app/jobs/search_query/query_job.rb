class SearchQuery::QueryJob < ApplicationJob
  queue_with_priority 0

  def perform(id)
    Language.define_searchable_event_classes

    search_query = SearchQuery.find(id)
    search_query.query!
  end
end
