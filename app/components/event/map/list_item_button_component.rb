class Event::Map::ListItemButtonComponent < EventComponent
  include EventComponent::Mappable

  def initialize(event, bookmarked:, seen:)
    super(event)
    @bookmarked = bookmarked
    @seen = seen
  end

  def bookmarked?
    @bookmarked
  end

  def seen?
    @seen
  end
end
