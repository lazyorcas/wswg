module Business::EventQuery::Filterable
  extend ActiveSupport::Concern

  def filter_by_month
    @events = @events.where("EXTRACT(MONTH FROM start_date::date) = ?", month)
  end

  def filter_by_dow
    @events = @events.where(dow: dow)
  end

  def filter_by_tod
    @events = @events.where(start_time: start_time..end_time)
  end

  def filter_by_min_attendees_count
    @events = @events.where("attendees_count >= ?", min_attendees_count)
  end

  def filter_by_max_attendees_count
    @events = @events.where("attendees_count <= ?", max_attendees_count)
  end

  def filter_by_source
    @events = @events
      .joins(:city_source)
      .where(city_sources: { source_id: source_id })
  end

  def filter_out_muted_keywords
    keywords = muted_keywords.split(/,\s*/)
    tsquery = keywords.map do |keyword|
      keyword.strip.split(/\s+/).join(" <-> ")
    end.join(" | ")
    @events = @events.where("keywords @@ (!!to_tsquery('#{tsquery}'))")
  end

  def start_time
    if tod == "morning"
      "00:00:00"
    elsif tod == "afternoon"
      "12:00:00"
    elsif tod == "evening"
      "18:00:00"
    end
  end

  def end_time
    if tod == "morning"
      "11:59:59"
    elsif tod == "afternoon"
      "17:59:59"
    elsif tod == "evening"
      "23:59:59"
    end
  end
end
