class Source::FindAndCreateThingsJob < ApplicationJob
  queue_with_priority 2

  retry_on Ferrum::NodeNotFoundError, wait: 1.minute, attempts: 3

  def perform(id)
    source = Source.find(id)
    source.find_and_create_things!
  end
end
