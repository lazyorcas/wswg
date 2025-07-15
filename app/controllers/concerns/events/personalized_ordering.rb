module Events::PersonalizedOrdering
  extend ActiveSupport::Concern

  include CurrentPerson::Settings::PreferencesHelper

  def build_next_personalized_event_batch_path
    @next_personalized_event_batch_path ||= begin
      params = {
        city_id: @city.id,
        event_category_slug: @event_category.slug,
        time_period_slug: @time_period.slug
      }
      map? ?
        map_next_personalized_event_batch_path(params) :
        next_personalized_event_batch_path(params)
    end
  end

  private

  def map?
    raise NotImplementedError
  end

  def next_personalized_event_batch_builder
    @next_personalized_event_batch_builder ||= NextPersonalizedEventBatchBuilder.new(
      city: @city,
      event_category: @event_category,
      time_period: @time_period,
      order_by: sort_by
    )
  end
end
