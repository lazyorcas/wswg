module FieldTestHelper
  def field_test_variant(experiment)
    field_test(experiment, exclude: Current.person.nil?)
  end
end
