module CityHelper
  def build_event_cache_key(event)
    key_array = [ dom_id(event), event.updated_at.to_s, @city.time_zone.current_date.to_s ]
    key_array << "bot" if browser.bot?
    key_array
  end
end
