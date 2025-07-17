module Events::Recommendations
  extend ActiveSupport::Concern

  def build_recommendation_batch_path(already_recommended_event_ids: [])
    @recommendation_batch_path ||= begin
      params = {
        city_id: @city&.id,
        event_category_slug: @event_category.slug,
        time_period_slug: @time_period.slug,
        map: map?,
        already_recommended_event_ids: already_recommended_event_ids
      }
      recommendation_batch_path(params)
    end
  end

  private

  def map?
    false
  end
end
