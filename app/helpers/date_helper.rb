module DateHelper
  def get_easy_date(date, time_zone:)
    today = Time.current.in_time_zone(time_zone).to_date

    if date == today
      "Today"
    elsif date == today + 1.day
      "Tomorrow"
    elsif date.beginning_of_week == today.beginning_of_week
      "This #{date.strftime("%A")}"
    elsif date.beginning_of_week == today.beginning_of_week + 7
      "Next #{date.strftime("%A")}"
    else
      date.strftime("%A, %B %d")
    end
  end
end
