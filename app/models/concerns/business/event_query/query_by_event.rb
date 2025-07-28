module Business::EventQuery::QueryByEvent
  extend ActiveSupport::Concern

  include Business::EventQuery::Filterable
  include Business::EventQuery::Limitable

  def query_by_event
    @events = event_scope
      .where("extended_keywords @@ to_tsquery(?)", event_title_keywords)
      .order(Arel.sql(order_by_relevance_to_event_sql))

    filter_by_dow if dow.present?
    filter_by_tod if tod.present?
    filter_by_source if source_id.present?

    limit_events
  end

  def event_title_keywords
    @event_title_keywords ||= event.title
      .gsub(/[^a-zA-Z0-9]/, " ")
      .gsub(/\s+/, " ")
      .split(" ")
      .join(" | ")
  end

  def order_by_relevance_to_event_sql
    ActiveRecord::Base.send(:sanitize_sql_array, [
      "ts_rank(extended_keywords, to_tsquery(?)) DESC",
      event_title_keywords
    ])
  end
end
