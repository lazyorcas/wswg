class OpenAI::ResponsesClient
  def initialize
    @model = OpenAI::DefaultConfig::MODEL
    @openai_client = OpenAI::Client.new
  end

  def ask(input:, instructions: nil, response_schema: nil)
    @response = @openai_client.responses.create(parameters: {
      model: @model,
      input: input,
      instructions: instructions,
      text: response_schema ? { format: response_schema } : nil
    })
  end

  def response
    text = @response.dig("output", 0, "content", 0, "text")
    JSON.parse(text)
  end
end
