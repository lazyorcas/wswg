class OpenAI::Tokenizer
  def initialize(model: OpenAI::DefaultConfig::MODEL_FOR_TOKENIZER)
    @encoding = Tiktoken.encoding_for_model(model)
  end

  def count_token(text)
    @encoding.encode(text).length
  end
end

# https://openai.com/index/gpt-4-1/
# CONTEXT_WINDOW = 1_000_000

# event_descriptions = Event.pluck(:description)
# tokens = event_descriptions.map do |description|
#   OpenAI::Tokenizer.new.count_token(description)
# end
# avg_token_count = tokens.sum / event_descriptions.length

# puts "Events: #{event_descriptions.length}"
# puts "Tokens: #{tokens.sum}"
# puts "Average: #{avg_token_count}"
# puts "Fittable: #{CONTEXT_WINDOW / avg_token_count}"
