class Event::Map::InfoWindowComponent < EventComponent
  include Turbo::FramesHelper

  def initialize(event, bookmark:)
    super(event)
    @bookmark = bookmark
  end
end
