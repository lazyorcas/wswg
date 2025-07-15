module Events::PersonalizedOrdering
  extend ActiveSupport::Concern

  include CurrentPerson::Settings::PreferencesHelper

  def build_next_personalized_event_batch_path
    @next_personalized_event_batch_path = next_personalized_event_batch_builder.build_path
  end

  private

  def next_personalized_event_batch_builder
    @next_personalized_event_batch_builder ||= NextPersonalizedEventBatchBuilder.new(
      city: @city,
      event_category: @event_category,
      time_period: @time_period,
      order_by: sort_by
    )
  end
end
