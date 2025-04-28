class Jina::Reader
  TIMEOUT = 20

  BASE_URL = "https://r.jina.ai"
  HEADERS = {
    "Authorization" => "Bearer #{ENV["JINA_API_KEY"]}",
    "X-Engine" => "browser",
    "X-Return-Format" => "markdown",
    "X-Timeout" => TIMEOUT
  }

  def fetch(url)
    jina_url = build_jina_url(url)
    cache_key = "jina:#{jina_url}"

    begin
      response = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
        HTTParty.get(
          jina_url,
          headers: headers,
          timeout: timeout,
        )
      end

      response.body

    rescue Net::ReadTimeout
      Rails.cache.delete(cache_key)
      raise Jina::TimeoutError.new(url)
    end
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
