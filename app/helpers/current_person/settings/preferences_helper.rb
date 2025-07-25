module CurrentPerson::Settings::PreferencesHelper
  include FieldTestHelper

  # Sort by
  def sort_by
    Current.person.settings(:preferences).sort_by ||
      field_test_variant(:sort_by_interests)
  end

  def sort_by_values
    values = []
    values << "interests" if Current.person.persisted?
    values += [ "popularity", "time" ]
    values
  end

  def sort_by_options
    sort_by_values.map do |value|
      [
        sort_by_label(value),
        value,
        selected: sort_by == value
      ]
    end
  end

  def sort_by_time?
    sort_by == "time"
  end

  def sort_by_popularity?
    sort_by == "popularity"
  end

  def sort_by_interests?
    sort_by == "interests"
  end

  def sort_by_label(value)
    value == "interests" ? "Recommended" : value.humanize
  end

  # Hide impression events
  def hide_impression_events_value
    Current.person.settings(:preferences).hide_impression_events ||
      field_test_variant(:hide_impression_events)
  end

  def hide_impression_events_values
    [ "hide", "show" ]
  end

  def hide_impression_events_label(value)
    value == "hide" ?
      "Hide already seen events" :
      "Show already seen events"
  end

  def hide_impression_events_options
    hide_impression_events_values.map do |value|
      [
        hide_impression_events_label(value),
        value,
        selected: hide_impression_events_value == value
      ]
    end
  end

  def hide_impression_events?
    hide_impression_events_value == "hide"
  end
end
