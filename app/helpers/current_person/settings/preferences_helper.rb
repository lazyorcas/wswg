module CurrentPerson::Settings::PreferencesHelper
  include FieldTestHelper

  def sort_by
    Current.person.settings(:preferences).sort_by
  end

  def sort_by_values
    values = []
    # values << "interests" if Current.person.persisted?
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
end
