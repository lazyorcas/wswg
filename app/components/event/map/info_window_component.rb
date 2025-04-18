class Event::Map::InfoWindowComponent < EventComponent
  include Turbo::FramesHelper

  attr_reader :bookmark

  def initialize(event, bookmark:)
    super(event)
    @bookmark = bookmark
  end
end
