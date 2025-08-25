module Businesses::Organizers::EventsHelper
  def business_organizer_events_table_headers
    headers = [
      {
        icon: "ph-text-aa",
        label: "Event",
        width: 30
      },
      {
        icon: "ph-map-pin",
        label: "Venue",
        width: 30
      },
      {
        icon: "ph-calendar",
        label: "Date",
        width: 10
      },
      {
        icon: "ph-clock",
        label: "Time",
        width: 10
      },
      {
        icon: "ph-eye",
        label: "Views",
        width: 10
      },
      {
        icon: "ph-cursor-click",
        label: "Clicks",
        width: 10
      }
    ]

    if (sum = headers.map { |header| header[:width] }.sum) != 100
      raise "Headers width (#{sum}) must sum to 100"
    end

    headers
  end
end
