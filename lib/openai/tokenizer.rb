class OpenAI::Tokenizer
  def initialize(model: OpenAI::DefaultConfig::MODEL_FOR_TOKENIZER)
    @encoding = Tiktoken.encoding_for_model(model)
  end

  def count_token(text)
    @encoding.encode(text).length
  end
end
