class Jina::Reader
  TIMEOUT = 20
  TIMEOUT_BUFFER = 2

  BASE_URL = "https://r.jina.ai"
  HEADERS = {
    "Authorization" => "Bearer #{ENV["JINA_API_KEY"]}",
    "X-Engine" => "browser",
    "X-Return-Format" => "markdown",
    "X-Timeout" => "#{TIMEOUT - TIMEOUT_BUFFER}"
  }

  def fetch(url)
    jina_url = build_jina_url(url)
    response = HTTParty.get(
      jina_url,
      headers: headers,
      timeout: timeout,
    )
    response.body
  end

  private

  def build_jina_url(url)
    "#{BASE_URL}/#{url}"
  end

  def headers
    HEADERS
  end

  def timeout
    TIMEOUT
  end
end
