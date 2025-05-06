class OpenAI::Assistants::Geographer
  INSTRUCTIONS = "You are a helpful geographer. You know all of the cities in the world in any language. For each task, you will be given a location and a question."

  def initialize
    @openai_responses_client = OpenAI::ResponsesClient.new
  end

  TRUE_OR_FALSE_INPUT_TEMPLATE = <<~TEXT
    # Location
    %{location}

    # Question
    %{question}
  TEXT

  def true_or_false?(location:, question:)
    input = build_input(
      input_template: TRUE_OR_FALSE_INPUT_TEMPLATE,
      location: location,
      question: question
    )

    response = @openai_responses_client.ask(
      input: input,
      instructions: INSTRUCTIONS,
      response_schema: OpenAI::Responses::Schemas.true_or_false_schema
    )

    response["answer"]
  end

  private

  def build_input(input_template:, **args)
    input_template % args
  end
end
