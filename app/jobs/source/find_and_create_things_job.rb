class Source::FindAndCreateThingsJob < ApplicationJob
  queue_with_priority 2

  retry_on Ferrum::NodeNotFoundError, wait: :polynomially_longer, attempts: 5

  def perform(id)
    source = Source.find(id)
    source.find_and_create_things!
  end
end
