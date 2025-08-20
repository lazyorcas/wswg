class AI::MarkdownExpert
  INSTRUCTIONS = "You are a helpful markdown expert. You are also a polygot in #{Language.pluck(:name).to_sentence}. For each task, you will be given a markdown in a language that you understand and some context for that task."

  CONVERT_TO_JSON_INPUT_TEMPLATE = <<~TEXT
    Convert the following markdown to JSON using the provided context.

    # Context
    %{context}

    ---

    # Markdown
    %{markdown}
  TEXT

  def initialize
    @chat = Chat.create(model_id: OpenAI::DefaultConfig::MODEL)
  end

  def convert_to_json(markdown, context:, schema:)
    input = build_input(
      input_template: CONVERT_TO_JSON_INPUT_TEMPLATE,
      context: context,
      markdown: markdown,
    )
    response = @chat
      .with_schema(schema)
      .with_instructions(INSTRUCTIONS)
      .with_temperature(0.0)
      .ask(input)
    response.content
  end

  private

  def build_input(input_template:, **args)
    input_template % args
  end
end
