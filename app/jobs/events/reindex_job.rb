class Events::ReindexJob < ApplicationJob
  queue_as :default

  def perform
    Event.reindex
  end
end
