module Events::Impressions
  def hide_impression_events
    @events = @events.joins("LEFT JOIN impressions ON impressions.event_id = events.id AND impressions.impressionable_type = '#{Current.person.class.name}' AND impressions.impressionable_id = #{Current.person.id}").where("impressions.id IS NULL")
  end
end
