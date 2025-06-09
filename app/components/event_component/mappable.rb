module EventComponent::Mappable
  include MapboxHelper

  SOURCE_ICON_SIZES = {
    "Meetup" => 32,
    "Luma" => 64,
    "Eventbrite" => 256,
    "MuenchenDe" => 32,
    "Ticketmaster" => 32
  }

  ICON_SIZE = 16

  def data
    location = @event.location

    coordinates = location.present? ?
      get_mapbox_coordinates(location.coordinates) :
      nil

    {
      action: "map#showFeaturePopup bottom-sheet#collapse",
      map_target: location.present? ? "item" : nil,
      map_feature: {
        type: "Feature",
        properties: {
          dom_id: dom_id(@event),
          info_window_path: map_event_path(@event, format: helpers.browser.device.mobile? ? :turbo_stream : :html),
          source_name: @event.source.name,
          source_icon_multiplier: 1.0 * ICON_SIZE / SOURCE_ICON_SIZES[@event.source.name]
        },
        geometry: {
          type: "Point",
          coordinates: coordinates
        }
      }
    }
  end
end
