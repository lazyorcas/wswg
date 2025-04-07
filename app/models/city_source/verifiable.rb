module CitySource::Verifiable
  extend ActiveSupport::Concern

  CONTEXT = "This markdown is a website that lists events."
  QUESTION = "Does this website list events in the city of %{city}?"

  included do
    scope :verified, -> { where(verified: true) }
    scope :unverified, -> { where(verified: false) }
  end

  def verify!
    markdown = jina_reader.fetch(url)
    raise "No markdown found for #{url}" if markdown.blank?

    question = QUESTION % { city: city.name }

    json = markdown_expert.ask_if_true_or_false(
      markdown,
      context: CONTEXT,
      question: question
    )
    raise "No JSON found for #{url}" if json.blank?

    self.verified = json["answer"]
    save!
  end

  def queue_verify
    VerifyJob.perform_later(id)
  end

  private

  def jina_reader
    @jina_reader ||= Jina::Reader.new
  end

  def markdown_expert
    @markdown_expert ||= OpenAI::Assistants::MarkdownExpert.new
  end
end
