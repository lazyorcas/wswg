module Businesses::EventsHelper
  def table_headers
    headers = [
      {
        icon: "ph-text-aa",
        label: "Title",
        width: 20
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
        filter_id: :date,
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
        filter_id: :attendees_count,
        icon: "ph-users",
        label: "Attendees",
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

  def month_options
    [
      [ "January", 1 ],
      [ "February", 2 ],
      [ "March", 3 ],
      [ "April", 4 ],
      [ "May", 5 ],
      [ "June", 6 ],
      [ "July", 7 ],
      [ "August", 8 ],
      [ "September", 9 ],
      [ "October", 10 ],
      [ "November", 11 ],
      [ "December", 12 ]
    ].map do |label, value|
      [ label, value, selected: value.to_s == event_query_params[:month] ]
    end
  end

  def tod_options
    [
      [ "Morning", "morning" ],
      [ "Afternoon", "afternoon" ],
      [ "Evening", "evening" ]
    ].map do |label, value|
      [ label, value, selected: value.to_s == event_query_params[:tod] ]
    end
  end

  def source_options
    Source.where.not(name: "Ticketmaster").map do |source|
      [ source.name, source.id, selected: source.id.to_s == event_query_params[:source_id] ]
    end
  end
end
