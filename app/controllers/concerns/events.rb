module Events
  extend ActiveSupport::Concern

  include CurrentPerson::Settings::PreferencesHelper
  include Filters
  include SEO
  include Batches
  include PersonalizedOrdering

  private

  def build_events
    @events = events_page_builder.build_events
  end

  def eager_load_events_associations
    @events = @events.includes(:source, :location, :city)
  end

  def build_map_path
    @map_path = events_page_builder.build_map_path
  end

  def events_page_builder
    @events_page_builder ||= Marketing::EventsPageBuilderFactory.build({
      city: @city,
      event_category: @event_category,
      time_period: @time_period,
      order_by: sort_by
    })
  end
end
