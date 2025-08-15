class TempJob < ApplicationJob
  queue_as :default

  def perform
    Event.where.not(organizer_url: nil).find_each do |event|
      event.assign_organizer!
    end

    Event.where.not(organizer_name: nil).find_each do |event|
      event.assign_organizer!
    end
  end
end
