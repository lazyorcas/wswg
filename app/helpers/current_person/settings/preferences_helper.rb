module CurrentPerson::Settings::PreferencesHelper
  include FieldTestHelper

  def sort_by
    Current.person.settings(:preferences).sort_by
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
end
