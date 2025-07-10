module Marketing::EventsPageBuilderFactory
  def self.build(params)
    if params[:city].persisted?
      if params[:event_category].events?
        Marketing::PageBuilder::CityEventsPageBuilder.new(
          city: params[:city],
          time_period: params[:time_period],
          order_by: params[:order_by]
        )
      else
        Marketing::PageBuilder::CitySearchQueryEventsPageBuilder.new(
          city: params[:city],
          time_period: params[:time_period],
          event_category: params[:event_category],
        )
      end
    else
      if params[:event_category].events?
        Marketing::PageBuilder::NearbyEventsPageBuilder.new(
          city: params[:city],
          time_period: params[:time_period],
          order_by: params[:order_by]
        )
      else
        Marketing::PageBuilder::NearbySearchQueryEventsPageBuilder.new(
          city: params[:city],
          time_period: params[:time_period],
          event_category: params[:event_category],
        )
      end
    end
  end
end
