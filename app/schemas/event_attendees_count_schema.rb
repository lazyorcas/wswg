class EventAttendeesCountSchema < RubyLLM::Schema
  any_of :attendees_count, description: "Number of attendees. Use null if unknown" do
    number
    null
  end
end
