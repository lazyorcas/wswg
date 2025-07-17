module Marketing::Events::Recommendations
  def filter_events_by_recommendations
    @events = @events
      .left_joins(:recommendations)
      .where(recommendations: { recommendable: @person })
  end

  def order_events_by_recommendations_ranks
    @events = @events
      .left_joins(:recommendations)
      .order(
        Recommendation.arel_table[:rank].desc.nulls_last,
        attendees_count: :desc,
        seens_count: :desc,
        start_date: :asc,
        start_time: :asc
      )
  end

  private

  def recommendations
    @recommendations ||= @person.recommendations
  end
end
