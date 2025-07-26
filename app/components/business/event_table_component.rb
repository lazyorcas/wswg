class Business::EventTableComponent < EventComponent
  def date
    Date.parse(@event.start_date).strftime("%a, %B %d")
  end

  def organizer
    if @event.organizer.present?
      @event.organizer.name || @event.organizer.url
    else
      nil
    end
  end

  def organizer_url
    if @event.organizer.present?
      @event.organizer.url || build_google_query_url_for_organizer
    else
      nil
    end
  end

  def venue
    if @event.location.present?
      @event.location.city_address
    else
      nil
    end
  end

  private

  def build_google_query_url_for_organizer
    intitle = @event.organizer.name
    inurl = @event.source.name.downcase
    query = "intitle:\"#{intitle}\" inurl:\"#{inurl}\""
    "https://www.google.com/search/?q=#{CGI.escape(query)}"
  end
end
