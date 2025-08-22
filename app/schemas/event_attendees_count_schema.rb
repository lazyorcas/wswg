class EventAttendeesCountSchema < RubyLLM::Schema
  number :attendees_count, description: "Number of attendees. Use null if unknown" do
    number
    null
  end
end
