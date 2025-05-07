class Event::DataIncompleteError < StandardError
  def initialize(event)
    super(event.errors.full_messages.join(", "))
  end
end
