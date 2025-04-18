class Events::ReindexJob < ApplicationJob
  queue_with_priority 0

  def perform
    Event.reindex
  end
end
