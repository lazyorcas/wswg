module Marketing::EventsPageBuilderFactory
  def self.build(params)
    if params[:city].persisted?
      if params[:event_category].events?
        Marketing::PageBuilder::CityEventsPageBuilder.new(**params)
      else
        Marketing::PageBuilder::CitySearchQueryEventsPageBuilder.new(**params)
      end
    else
      if params[:event_category].events?
        Marketing::PageBuilder::NearbyEventsPageBuilder.new(**params)
      else
        Marketing::PageBuilder::NearbySearchQueryEventsPageBuilder.new(**params)
      end
    end
  end
end
