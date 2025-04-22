module Event::Fetchable
  extend ActiveSupport::Concern

  def fetch!
    fetch
    save!
  end

  def fetch
    markdown = jina_reader.fetch(url)
    json = markdown_expert.convert_to_json(markdown, json_schema: json_schema)

    self.attributes = json.slice(*self.class.column_names)

    if json["location"].present?
      if city.precise?(json["location"])
        self.location_query = json["location"]

      elsif !city.contains?(json["location"])
        self.location_query = "#{json["location"]}, #{city.name}"
      end
    end
  end

  private

  def json_schema
    OpenAI::Responses::Schemas.event_schema(
      time_zone: city.time_zone
    )
  end

  def jina_reader
    @jina_reader ||= Jina::Reader.new
  end

  def markdown_expert
    @markdown_expert ||= OpenAI::Assistants::MarkdownExpert.new
  end
end
