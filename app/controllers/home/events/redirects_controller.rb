class Home::Events::RedirectsController < ApplicationController
  def show
    load_event
    redirect_to(
      all_city_events_path(city_slug: @event.city.slug, event_category_slug: "events"),
      status: :moved_permanently
    )
  end

  private

  def load_event
    @event = Event.find(params[:id])
  end
end
