class OpenAI::ResponsesClient
  attr_reader :response

  def initialize
    @model = OpenAI::DefaultConfig::MODEL
    @openai_client = OpenAI::Client.new
  end

  def ask(input:, instructions: nil, response_schema: nil)
    open_ai_response = @openai_client.responses.create(parameters: {
      model: @model,
      input: input,
      instructions: instructions,
      text: response_schema ? { format: response_schema } : nil
    })

    @response = build_response(open_ai_response)
  end

  private

  def build_response(open_ai_response)
    text = open_ai_response.dig("output", 0, "content", 0, "text")
    JSON.parse(text)
  end
end
