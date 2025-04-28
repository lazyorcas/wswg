class Jina::Reader
  TIMEOUT = 20

  BASE_URL = "https://r.jina.ai"
  HEADERS = {
    "Authorization" => "Bearer #{ENV["JINA_API_KEY"]}",
    "X-Engine" => "browser",
    "X-Return-Format" => "markdown",
    "X-Timeout" => TIMEOUT.to_s
  }

  def fetch(url)
    jina_url = build_jina_url(url)
    cache_key = "jina:#{jina_url}"

    begin
      Rails.cache.fetch(cache_key, expires_in: 1.hour) do
        response = HTTParty.get(
          jina_url,
          headers: headers,
          timeout: timeout,
        )
        response.body
      end
    rescue Net::ReadTimeout
      raise Jina::TimeoutError.new(url)
    rescue => e
      Rails.cache.delete(cache_key)
      raise e
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
