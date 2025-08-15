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

  def filter_by_source
    @events = @events
      .joins(:city_source)
      .where(city_sources: { source_id: source_id })
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
