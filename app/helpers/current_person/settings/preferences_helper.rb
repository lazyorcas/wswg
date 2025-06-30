module CurrentPerson::Settings::PreferencesHelper
  def should_test_sort_by?
    Current.person.present? && (Current.person.is_a?(Visitor) || Current.person.id != 1)
  end

  def sort_by
    if browser.bot?
      "time"
    else
      Current.person.settings(:preferences).sort_by || field_test(:sort_by)
    end
  end

  def sort_by_values
    [ "time", "popularity" ]
  end

  def sort_by_options
    sort_by_values.map do |value|
      [ value.humanize, value, selected: sort_by == value ]
    end
  end

  def sort_by_time?
    sort_by == "time"
  end

  def sort_by_popularity?
    sort_by == "popularity"
  end

  def sort_by_converted
    return unless should_test_sort_by?
    field_test_converted(:sort_by)
  end
end
