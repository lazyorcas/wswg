module Event::Fetchable
  extend ActiveSupport::Concern

  include Parseable

  def found?
    json.present?
  end

  def fetch
    _fetch
    parse
  end

  private

  def _fetch
    @markdown = jina_reader.fetch(url)
  end

  def markdown
    @markdown
  end

  def jina_reader
    @jina_reader ||= Jina::Reader.new
  end
end
