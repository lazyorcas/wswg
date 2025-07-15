module CacheHelper
  def build_event_cache_key(event, is_map: false)
    key = [ dom_id(event), event.updated_at.to_s, @city.present? ? @city.time_zone.current_date.to_s : nil ]
    key << "map" if is_map
    key
  end
end
