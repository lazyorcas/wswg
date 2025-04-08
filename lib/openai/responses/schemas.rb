class OpenAI::Responses::Schemas
  def self.true_or_false_schema
    build_schema("true_or_false", {
      answer: {
        type: "boolean"
      }
    })
  end

  # def self.thing_types_schema
  #   build_schema("thing_types", {
  #     thing_types: {
  #       type: "array",
  #       description: "A list of thing types that the user is looking for. If the user is looking for all types, return only an array with type \"Thing\".",
  #       items: {
  #         type: "object",
  #         properties: {
  #           type: {
  #             type: "string",
  #             enum: %w[ Thing Event ]
  #           },
  #           query: {
  #             type: "string",
  #             description: "Extracted from the user's query. The query should be related to type of thing that the user is looking for. The query can have many keywords that are shared by multiple types. The query should be downcased."
  #           }
  #         },
  #         required: [ "type", "query" ],
  #         additionalProperties: false
  #       }
  #     }
  #   })
  # end

  def self.event_schema(time_zone:)
    current_year = Date.today.in_time_zone(time_zone).year

    build_schema("event", {
      title: { type: "string" },
      description: {
        type: "string",
        description: "Full description in markdown format."
      },
      image_url: { type: "string" },
      location: {
        type: "string",
        description: "Full address of the event. If not available, return an empty string. If the address only contains a city name, return an empty string."
      },
      start_date: {
        type: "string",
        description: "Start date of the event in YYYY-MM-DD format. The current year is #{current_year} if not mentioned."
      },
      start_time: {
        type: "string",
        description: "Start time of the event in HH:mm:ss format."
      },
      end_date: {
        type: "string",
        description: "End date of the event in YYYY-MM-DD format. The current year is #{current_year} if not mentioned."
      },
      end_time: {
        type: "string",
        description: "End time of the event in HH:mm:ss format."
      },
      price: {
        type: "number",
        description: "Price of the event. If there's a range, return the minimum price. Round up to the nearest integer. If the price is not available or free, return 0."
      }
    })
  end

  def self.event_search_query_schema
    build_schema("event_search_query", {
      keywords: {
        type: "string",
        description: "Keywords that will be input to OpenSearch. Each keyword should be separated by a blank space. The keywords should be downcased."
      },
      date_range: {
        type: "object",
        properties: {
          city: {
            type: "string",
            description: "City name. If not mentioned, return an empty string.",
            enum: [ *City.pluck(:name), "" ]
          },
          start_date: {
            type: "string",
            description: "Start date in YYYY-MM-DD format. If not mentioned, return an empty string."
          },
          start_time: {
            type: "string",
            description: "Start time in HH:mm:ss format. If not mentioned, return an empty string."
          },
          end_date: {
            type: "string",
            description: "End date in YYYY-MM-DD format. If not mentioned, return an empty string."
          },
          end_time: {
            type: "string",
            description: "End time in HH:mm:ss format. If not mentioned, return an empty string."
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

  private

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
