class String
  def professionalize
    remove_empty_space_before_question_mark
    .remove_extra_spaces
    .capitalize_first_letter
  end

  def remove_empty_space_before_question_mark
    gsub(/\s+\?/, "?")
  end

  def remove_extra_spaces
    gsub(/\s{2,}/, " ")
  end

  def capitalize_first_letter
    slice(0, 1).capitalize + slice(1..-1)
  end
end
