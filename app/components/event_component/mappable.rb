module EventComponent::Mappable
  SOURCE_ICON_SIZES = {
    "Meetup" => 32,
    "Luma" => 64,
    "Eventbrite" => 256
  }

  ICON_SIZE = 16.0

  def data
    {
      action: "map#showFeaturePopup bottom-sheet#collapse",
      map_target: "item",
      map_feature: {
        type: "Feature",
        properties: {
          dom_id: dom_id(event),
          info_window_path: event_path(event, context: "map"),
          source_name: source.name,
          source_icon_multiplier: ICON_SIZE / SOURCE_ICON_SIZES[source.name]
        },
        geometry: {
          type: "Point",
          coordinates: location&.coordinates || city.scattered_coordinates
        }
      }
    }
  end
end
