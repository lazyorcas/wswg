module DateHelper
  def relative_date(_date, time, time_zone:)
    date = _date.class == String ? Date.parse(_date) : _date
    current_date = time_zone.current_date

    if date < current_date
      date.strftime("%A, %B %d")
    elsif date == current_date
      if time.to_time.hour >= 18
        "Tonight"
      else
        "Today"
      end
    elsif date == current_date + 1.day
      "Tomorrow"
    elsif date.beginning_of_week == current_date.beginning_of_week
      "This #{date.strftime("%A")}"
    elsif date.beginning_of_week == current_date.beginning_of_week + 7
      "Next #{date.strftime("%A")}"
    else
      date.strftime("%A, %B %d")
    end
  end
end
