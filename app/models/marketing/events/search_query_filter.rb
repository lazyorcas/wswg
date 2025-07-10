module Marketing::Events::SearchQueryFilter
  def filter_events_by_search_query
    @events = @events.where(id: @search_query&.result&.event_ids)
  end

  def order_events_by_search_query
    @events = @events.in_order_of(:id, @search_query&.result&.event_ids || [])
  end

  private

  def load_search_query
    @search_query = SearchQuery
      .where(
        query: event_category.query,
        city_id: city.id,
        status: :completed,
        searcher: nil
      )
      .order(created_at: :desc)
      .first
  end
end
