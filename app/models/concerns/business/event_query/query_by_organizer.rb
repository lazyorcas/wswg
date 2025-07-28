module Business::EventQuery::QueryByOrganizer
  extend ActiveSupport::Concern

  include Business::EventQuery::Filterable
  include Business::EventQuery::Limitable

  def query_by_organizer
    @events = event_scope
      .where(organizer_id: organizer_id)
      .order(id: :desc)

    filter_by_dow if dow.present?
    filter_by_tod if tod.present?
    filter_by_source if source_id.present?

    limit_events
  end
end
