module FieldTestHelper
  EXPERIMENT_FALLBACK = {
    search_bar_position: "header",
    sort_by: "time",
    sort_by_interests: "popularity",
    hide_impression_events: "show"
  }.freeze

  def field_test_variant(experiment)
    if should_test?
      field_test(experiment)
    else
      EXPERIMENT_FALLBACK[experiment]
    end
  end

  def convert_field_test(experiment)
    field_test_converted(experiment) if should_test?
  end

  private

  def should_test?
    Current.person.persisted? && (Current.person.is_a?(Visitor) || Current.person.id != 1)
  end
end
