module Events::Recommendations
  extend ActiveSupport::Concern

  def build_recommendation_batch_path
    @recommendation_batch_path ||= begin
      params = {
        city_id: @city.id,
        event_category_slug: @event_category.slug,
        time_period_slug: @time_period.slug,
        recommendation_batch_render_mode: recommendation_batch_render_mode,
        already_recommended_event_ids: already_recommended_event_ids
      }
      recommendation_batch_path(params)
    end
  end

  private

  def recommendation_batch_render_mode
    raise NotImplementedError
  end

  def already_recommended_event_ids
    raise NotImplementedError
  end
end
