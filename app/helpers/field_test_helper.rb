module FieldTestHelper
  EXPERIMENT_DEFAULT = {
    search_bar_position: "header",
    sort_by: "time"
  }.freeze

  def field_test_variant(experiment)
    if should_test?
      field_test(experiment)
    else
      EXPERIMENT_DEFAULT[experiment]
    end
  end

  def convert_field_test(experiment)
    field_test_converted(experiment) if should_test?
  end

  private

  def should_test?
    Current.person.present? && (Current.person.is_a?(Visitor) || Current.person.id != 1)
  end
end
