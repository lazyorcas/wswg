module Marketing::Events::TimePeriodFilters
  def filter_events_by_time_period
    if start_time.present?
      filter_events_by_start_time
    else
      filter_events_by_start_date
    end
    if end_date.present?
      filter_events_by_end_date
    end
  end

  def filter_events_by_start_time
    @events = @events.where("CONCAT(start_date, 'T', start_time) >= ?", "#{start_date}T#{start_time}")
  end

  def filter_events_by_start_date
    @events = @events.where("start_date >= ?", start_date)
  end

  def filter_events_by_end_date
    @events = @events.where("end_date <= ?", end_date)
  end

  private

  def start_date
    @start_date ||= @time_period.start_date
  end

  def start_time
    @start_time ||= @time_period.start_time
  end

  def end_date
    @end_date ||= @time_period.end_date
  end

  def end_time
    @end_time ||= @time_period.end_time
  end
end
