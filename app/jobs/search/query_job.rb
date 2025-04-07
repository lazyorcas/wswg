class Search::QueryJob < ApplicationJob
  queue_as :default

  def perform(id)
    search = Event::Search.find(id)
    search.query!
  end
end
