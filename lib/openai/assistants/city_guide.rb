# class OpenAI::Assistants::CityGuide
#   INSTRUCTIONS = "You are a city guide who knows exactly what the user is looking for.".freeze
#   INPUT_TEMPLATE = <<-TEXT
#     What is this user looking for?

#     ## User Input
#     %{text}
#   TEXT

#   def initialize
#     @openai_responses_client = OpenAI::ResponsesClient.new
#     @instructions = INSTRUCTIONS
#     @input_template = INPUT_TEMPLATE
#   end

#   def ask_for_thing_types(text)
#     input = build_input(text)

#     @openai_responses_client.ask(
#       input: input,
#       instructions: @instructions,
#       response_schema: OpenAI::Responses::Schemas.thing_types_schema
#     )
#   end

#   private

#   def build_input(text)
#     @input_template % { text: text }
#   end
# end
