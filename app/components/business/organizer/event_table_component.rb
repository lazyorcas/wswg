class Business::Organizer::EventTableComponent < EventComponent
  def date
    Date.parse(@event.start_date).strftime("%a, %B %d")
  end

  def venue
    if @event.location.present?
      @event.location.city_address
    else
      nil
    end
  end
end
