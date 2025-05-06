module OpenAI::Responses::Schemas
  def self.true_or_false_schema
    build_schema("true_or_false", {
      answer: {
        type: "boolean"
      }
    })
  end

  def self.event_schema
    build_schema("event", {
      title: {
        type: "string",
        description: "Title of the event. If not mentioned, return an empty string."
      },
      description: {
        type: "string",
        description: "Full description in markdown format. If not mentioned, return an empty string."
      },
      image_url: {
        type: "string"
      },
      location: {
        type: "string",
        description: "Location of the event. It can be a precise address or a general area. If not mentioned, return an empty string. If the location is online / virtual, return an empty string. If the location is to be determined / TBD, return an empty string."
      },
      start_date: {
        type: "string",
        description: "Start date of the event in YYYY-MM-DD format. If not mentioned, return an empty string."
      },
      start_time: {
        type: "string",
        description: "Start time of the event in HH:mm:ss format. If not mentioned, return an empty string."
      },
      end_date: {
        type: "string",
        description: "End date of the event in YYYY-MM-DD format. If not mentioned and the start date is mentioned, return the same date as the start date. If not mentioned and the start date is also not mentioned, return an empty string."
      },
      end_time: {
        type: "string",
        description: "End time of the event in HH:mm:ss format. If not mentioned, return an empty string."
      },
      price: {
        type: "number",
        description: "Price of the event. If there's a range, return the minimum price. Round up to the nearest integer. If the price is not available or free, return 0."
      },
      not_found: {
        type: "boolean",
        description: "If the event is not found, return true. Otherwise, return false."
      }
    })
  end

  def self.city_schema
    build_schema("city", {
      city: {
        type: "string",
        description: "City name. If not mentioned, return an empty string. If the city isn't in the list of supported cities, return \"NOT_SUPPORTED\".",
        enum: [ *City.pluck(:name), "NOT_SUPPORTED", "" ]
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
