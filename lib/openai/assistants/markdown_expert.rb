class OpenAI::Assistants::MarkdownExpert
  INSTRUCTIONS = "You are a helpful markdown expert.".freeze
  CONVERT_TO_JSON_INPUT_TEMPLATE = <<-TEXT
    Convert the following markdown to JSON.
    ---
    %{markdown}
  TEXT
  TRUE_OR_FALSE_INPUT_TEMPLATE = <<-TEXT
    Context: %{context}
    Question: %{question}
    ---
    %{markdown}
  TEXT

  attr_reader :response

  def initialize
    @openai_responses_client = OpenAI::ResponsesClient.new
    @instructions = INSTRUCTIONS
  end

  def convert_to_json(markdown, json_schema:)
    input = build_input(
      input_template: CONVERT_TO_JSON_INPUT_TEMPLATE,
      markdown: markdown
    )

    @openai_responses_client.ask(
      input: input,
      instructions: @instructions,
      response_schema: json_schema
    )
  end

  def ask_if_true_or_false(markdown, context:, question:)
    input = build_input(
      input_template: TRUE_OR_FALSE_INPUT_TEMPLATE,
      markdown: markdown,
      context: context,
      question: question
    )

    @openai_responses_client.ask(
      input: input,
      instructions: @instructions,
      response_schema: OpenAI::Responses::Schemas.true_or_false_schema
    )
  end

  private

  def build_input(input_template:, **args)
    input_template % args
  end
end
