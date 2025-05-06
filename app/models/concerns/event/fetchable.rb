module Event::Fetchable
  extend ActiveSupport::Concern

  def fetch
    self.markdown = jina_reader.fetch(url)
  end

  private

  def jina_reader
    @jina_reader ||= Jina::ReaderClient.new
  end
end
