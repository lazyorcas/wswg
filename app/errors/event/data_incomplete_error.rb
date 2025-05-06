class Event::DataIncompleteError < StandardError
  def initialize(event)
    errors = event.errors.reject { |error| error.type == :data_incomplete }
    super(errors.full_messages.join(", "))
  end
end
