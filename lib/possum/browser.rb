class Possum::Browser < Ferrum::Browser
  WINDOW_SIZE = [ 1920, 1080 ]
  SCROLL_DISTANCE = 10_000
  NETWORK_IDLE_TIMEOUT = 5
  REJECTABLE_URL_PATTERNS = [
    /\.(png|jpg|jpeg|svg|gif|webp|ico|woff2|woff|ttf|otf|eot|css)(\?.*)?$/i
  ]

  def initialize(
    timeout: Fetch::DefaultConfig::TIMEOUT,
    headers: Fetch::DefaultConfig::HEADERS,
    window_size: WINDOW_SIZE,
    proxy: false
  )
    super(
      timeout: timeout,
      browser_options: {
        "no-sandbox": nil,
        "ignore-certificate-errors" => nil
      },
      ws_url: ENV["CHROMIUM_URL"],
      proxy: proxy ? {
        host: ENV["PROXY_HOST"],
        port: ENV["PROXY_PORT"],
        user: ENV["PROXY_USERNAME"],
        password: ENV["PROXY_PASSWORD"]
      } : nil,
      window_size: window_size
    )

    self.headers.set(headers)
    reject_requests
  end

  def scroll_to_load
    execute("window.scrollTo({ top: #{SCROLL_DISTANCE}, behavior: 'smooth' })")
  end

  def wait_for_idle
    network.wait_for_idle(timeout: NETWORK_IDLE_TIMEOUT)
  end

  private

  def reject_requests
    network.intercept
    on(:request) do |request|
      if REJECTABLE_URL_PATTERNS.any? { |pattern| request.url.match?(pattern) }
        request.abort
      else
        request.continue
      end
    end
  end
end
