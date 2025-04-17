class Search::QueryJob < ApplicationJob
  queue_with_priority 0

  def perform(id)
    search = Event::Search.find(id)
    search.query!
  end
end
