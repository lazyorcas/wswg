class Jina::TimeoutError < StandardError
  attr_reader :url

  def initialize(url)
    @url = url
  end
end
