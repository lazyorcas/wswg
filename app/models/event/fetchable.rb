module Event::Fetchable
  extend ActiveSupport::Concern

  def fetch!
    markdown = jina_reader.fetch(url)
    raise "No markdown found for #{url}" if markdown.blank?

    json = markdown_expert.convert_to_json(markdown, json_schema: json_schema)
    raise "No JSON found for #{url}" if json.blank?

    self.attributes = json.slice(*self.class.column_names)
    self.data = json

    save!
  end

  private

  def json_schema
    OpenAI::Responses::Schemas.event_schema
  end

  def jina_reader
    @jina_reader ||= Jina::Reader.new
  end

  def markdown_expert
    @markdown_expert ||= OpenAI::Assistants::MarkdownExpert.new
  end
end
