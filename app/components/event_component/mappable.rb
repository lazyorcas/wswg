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
      event_id: @event.id,
      action: "bottom-sheet#collapse map#showFeaturePopup seens#createSeen",
      map_target: location.present? ? "item" : nil,
      impressions_target: "event",
      map_feature: {
        type: "Feature",
        properties: {
          event_id: @event.id,
          dom_id: dom_id(@event),
          info_window_path: map_event_path(@event),
          source_name: @event.source.name,
          source_icon_multiplier: 1.0 * ICON_SIZE / SOURCE_ICON_SIZES[@event.source.name]
        },
        geometry: {
          type: "Point",
          coordinates: coordinates
        }
      },
      seens_event_id_param: @event.id,
      seens_seen_path_param: seen_path(source: "map_list_item")
    }
  end
end
