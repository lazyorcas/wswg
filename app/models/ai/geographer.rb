class AI::Geographer
  INSTRUCTIONS = "You are a helpful geographer. You know all of the cities in the world in any language. For each task, you will be given a location and a question."

  TRUE_OR_FALSE_INPUT_TEMPLATE = <<~TEXT
    # Location
    %{location}

    # Question
    %{question}
  TEXT

  def initialize
    @chat = Chat.create(model_id: OpenAI::DefaultConfig::MODEL)
  end

  def true_or_false?(location:, question:)
    input = build_input(
      input_template: TRUE_OR_FALSE_INPUT_TEMPLATE,
      location: location,
      question: question
    )
    response = @chat
      .with_schema(TrueOrFalseSchema)
      .with_instructions(INSTRUCTIONS)
      .ask(input)
    response.content["answer"]
  end

  private

  def build_input(input_template:, **args)
    input_template % args
  end
end
