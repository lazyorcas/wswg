class Source::FindAndCreateThingsJob < ApplicationJob
  queue_with_priority 1

  def perform(id)
    source = Source.find(id)
    source.find_and_create_things!
  end
end
