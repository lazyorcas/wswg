module OpenAI::Responses::Schemas
  def self.true_or_false_schema
    build_schema("true_or_false", {
      answer: {
        type: "boolean"
      }
    })
  end

  def self.city_schema
    build_schema("city", {
      city: {
        type: "string",
        description: "City name. If not mentioned, return an empty string. If the city isn't in the list of supported cities, return \"NOT_SUPPORTED\".",
        enum: [ *City.enabled.pluck(:name), "NOT_SUPPORTED", "" ]
      }
    })
  end

  def self.search_query_schema
    build_schema("search_query", {
      language_keywords: {
        type: "array",
        items: {
          type: "object",
          properties: {
            language: {
              type: "string",
              enum: Language.pluck(:name)
            },
            keywords: {
              type: "string",
              description: "Keywords that will be input to Elasticsearch. Each keyword should be separated by a blank space. The keywords should be downcased."
            }
          },
          required: [ "language", "keywords" ],
          additionalProperties: false
        }
      },
      date_range: {
        type: "object",
        properties: {
          start_date: {
            type: "string",
            description: "Start date in YYYY-MM-DD format. If it's not mentioned, return an empty string."
          },
          start_time: {
            type: "string",
            description: "Start time in HH:mm:ss format. If it's not mentioned, return an empty string."
          },
          end_date: {
            type: "string",
            description: "End date in YYYY-MM-DD format. If it's not mentioned, return an empty string."
          },
          end_time: {
            type: "string",
            description: "End time in HH:mm:ss format. If it's not mentioned, return an empty string."
          }
        },
        required: [ "start_date", "start_time", "end_date", "end_time" ],
        additionalProperties: false
      },
      max_price: {
        type: "number",
        description: "If not mentioned, return -1. If free, return 0."
      }
    })
  end

  def self.build_schema(name, properties)
    JSON.parse({
      type: "json_schema",
      name: name,
      strict: true,
      schema: {
        type: "object",
        properties: properties,
        required: properties.keys,
        additionalProperties: false
      }
    }.to_json)
  end
end
