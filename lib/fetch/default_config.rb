module Fetch::DefaultConfig
  TIMEOUT = 5
  HEADERS = {
    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Safari/537.36"
  }.freeze

  private

  def fetch_timeout
    TIMEOUT
  end

  def fetch_headers
    HEADERS
  end
end
