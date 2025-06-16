class SearchQuery::Result < Search::Result
  EVENT_LIMIT = 100

  def build(searches_results)
    self.hits = []
    self.count = 0
    self.took = 0

    searches_results.each do |search_result|
      self.hits += search_result.hits
      self.count += search_result.count
      self.took += search_result.took
      self.error = search_result.error if self.error.nil?
    end

    take_unique_hits
  end

  def inlier_ids
    return [] if hits.empty?
    return ids if all_scores_are_equal?

    @inlier_ids ||= begin
      data = hits.map { |hit| [ hit.id, hit.score ] }
      Statistics.calculate_inliers(data).map { |id, _| id }
    end
  end

  def events
    return [] if inlier_ids.empty?

    @events ||= begin
      events_with_scores = Event
        .find(inlier_ids)
        .map.with_index { |event, index| [ event, scores[index] ] }

      events_with_scores
        .sort_by { |event, score| all_scores_are_equal? ? event.start_datetime : 1.0 / score }
        .map { |event, _| event }
        .take(EVENT_LIMIT)
    end
  end

  def event_ids
    @event_ids ||= events.map(&:id)
  end

  def all_scores_are_equal?
    return nil if scores.empty?
    scores.uniq.length == 1
  end

  private

  def take_unique_hits
    self.hits = hits
      .sort_by { |hit| hit.score }.reverse
      .uniq { |hit| hit.id }
  end
end
