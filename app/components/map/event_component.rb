class Map::EventComponent < EventComponent
  def data_action
    actions = [ "mouseenter->map#removeAllPopups" ]
    actions << "mouseenter->map#showFeaturePopupOnHover" if location.present?
    actions.join(" ")
  end

  def data
    data = {
      action: data_action
    }

    if location.present?
      data = {
        **data,
        map_target: "item",
        map_feature: {
          type: "Feature",
          properties: {
            dom_id: dom_id(event),
            info_window_path: event_path(event, context: "map")
          },
          geometry: {
            type: "Point",
            coordinates: [ location.longitude, location.latitude ]
          }
        }
      }
    end

    data
  end
end
