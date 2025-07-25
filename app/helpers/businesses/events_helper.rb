module Businesses::EventsHelper
  def table_headers
    headers = [
      {
        icon: "ph-text-aa",
        label: "Title",
        width: 30
      },
      {
        icon: "ph-megaphone",
        label: "Organizer",
        width: 20
      },
      {
        icon: "ph-map-pin",
        label: "Venue",
        width: 20
      },
      {
        filter_id: :dow,
        icon: "ph-calendar",
        label: "Date",
        width: 10
      },
      {
        filter_id: :tod,
        icon: "ph-clock",
        label: "Time",
        width: 10
      },
      {
        filter_id: :source,
        icon: "ph-globe",
        label: "Source",
        width: 10
      }
    ]

    if headers.map { |header| header[:width] }.sum != 100
      raise "Headers width must sum to 100"
    end

    headers
  end

  def dow_options
    [
      [ "Monday", 1 ],
      [ "Tuesday", 2 ],
      [ "Wednesday", 3 ],
      [ "Thursday", 4 ],
      [ "Friday", 5 ],
      [ "Saturday", 6 ],
      [ "Sunday", 7 ]
    ].map do |label, value|
      [ label, value, selected: value.to_s == event_query_params[:dow] ]
    end
  end

  def tod_options
    [
      [ "Morning", "morning" ],
      [ "Afternoon", "afternoon" ],
      [ "Evening", "evening" ]
    ].map do |label, value|
      [ label, value, selected: value == event_query_params[:tod] ]
    end
  end

  def source_options
    Source.all.map do |source|
      [ source.name, source.id, selected: source.id == event_query_params[:source_id] ]
    end
  end
end
