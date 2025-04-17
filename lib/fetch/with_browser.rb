module Fetch::WithBrowser
  WINDOW_SIZE = [ 1920, 1080 ]
  SCROLL_DISTANCE = 10_000
  NETWORK_IDLE_TIMEOUT = 5

  private

  def load_browser(window_size: WINDOW_SIZE)
    @browser = Ferrum::Browser.new(
      timeout: browser_timeout,
      browser_options: { 'no-sandbox': nil },
      ws_url: ENV["CHROMIUM_URL"],
      window_size: window_size
    )
    @browser.headers.set(browser_headers)
  end

  def browser_headers
    Fetch::DefaultConfig::HEADERS
  end

  def browser_timeout
    Fetch::DefaultConfig::TIMEOUT
  end

  def browser_scroll_to_load
    @browser.execute("window.scrollTo({ top: #{SCROLL_DISTANCE}, behavior: 'smooth' })")
    @browser.network.wait_for_idle(timeout: NETWORK_IDLE_TIMEOUT)
  end
end
