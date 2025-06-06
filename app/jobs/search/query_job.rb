class Search::QueryJob < ApplicationJob
  queue_as :user

  def perform(id)
    search = Search.find(id)
    search.query!
  end
end
