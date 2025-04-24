# https://railsnotes.xyz/blog/ferrum-stealth-browsing

class Possum::Browser < Ferrum::Browser
  DEFAULT_TIMEOUT = 10
  WINDOW_SIZE = [ 1366, 768 ]
  SCROLL_DISTANCE = 10_000
  NETWORK_IDLE_TIMEOUT = 5

  HEADERS = {
    "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "Accept-Encoding" => "gzip, deflate, br, zstd",
    "Accept-Language" => "en-GB,en-US;q=0.9,en;q=0.8",
    "Cache-Control" => "no-cache",
    "Pragma" => "no-cache",
    "Priority" => "u=0, i",
    "Sec-Ch-Ua" => '"Google Chrome";v="131", "Chromium";v="131", "Not_A Brand";v="24"',
    "Sec-Ch-Ua-Mobile" => "?0",
    "Sec-Ch-Ua-Platform" => "\"macOS\"",
    "Sec-Fetch-Dest" => "document",
    "Sec-Fetch-Mode" => "navigate",
    "Sec-Fetch-Site" => "cross-site",
    "Sec-Fetch-User" => "?1",
    "Upgrade-Insecure-Requests" => "1",
    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
  }

  BLOCKED_IMAGE_EXTENSIONS = %w[.jpg .jpeg .png .gif .bmp .svg .webp]
  BLOCKED_VIDEO_EXTENSIONS = %w[.mp4 .avi .mov .mkv .webm]
  BLOCKED_SOUND_EXTENSIONS = %w[.mp3 .ogg .wav .aac .flac]
  BLOCKED_FONT_EXTENSIONS = %w[.woff .woff2 .ttf .otf .eot]
  BLOCKED_FILETYPES = BLOCKED_IMAGE_EXTENSIONS + BLOCKED_VIDEO_EXTENSIONS + BLOCKED_SOUND_EXTENSIONS + BLOCKED_FONT_EXTENSIONS

  def initialize(
    timeout: DEFAULT_TIMEOUT,
    headers: HEADERS,
    window_size: WINDOW_SIZE,
    proxy: false
  )
    super(
      headless: "new",
      timeout: timeout,
      browser_options: {
        "no-sandbox": nil,
        "disable-blink-features" => "AutomationControlled"
      },
      ws_url: ENV["CHROMIUM_URL"],
      # proxy: proxy ? {
      #   host: ENV["PROXY_HOST"],
      #   port: ENV["PROXY_PORT"],
      #   user: ENV["PROXY_USERNAME"],
      #   password: ENV["PROXY_PASSWORD"]
      # } : nil,
      window_size: window_size
    )

    self.headers.set(headers)
    reject_redundant_requests
  end

  def scroll_to_load
    execute("window.scrollTo({ top: #{SCROLL_DISTANCE}, behavior: 'smooth' })")
  end

  def wait_for_idle
    network.wait_for_idle(timeout: NETWORK_IDLE_TIMEOUT)
  end

  def click_on(selector)
    execute("document.querySelector('#{selector}').click()")
  end

  private

  def reject_redundant_requests
    network.intercept
    on(:request) do |request|
      if BLOCKED_FILETYPES.any? { |ext| request.url.end_with?(ext) }
        request.abort
      else
        request.continue
      end
    end
  end
end
