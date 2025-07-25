module Businesses::EventsHelper
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
