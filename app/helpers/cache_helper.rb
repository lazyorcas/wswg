module CacheHelper
  def build_event_cache_key(event)
    [ dom_id(event), event.updated_at.to_s, @city.time_zone.current_date.to_s ]
  end
end
