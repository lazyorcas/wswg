class Events::LocateJob < ApplicationJob
  queue_as :default

  def perform
    Event.locate
  end
end
