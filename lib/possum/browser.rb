# https://railsnotes.xyz/blog/ferrum-stealth-browsing

class Possum::Browser < Ferrum::Browser
  TIMEOUT = 10
  WINDOW_SIZE = [ 1366, 768 ]

  def initialize(
    timeout: TIMEOUT,
    window_size: WINDOW_SIZE
  )
    super(
      headless: "new",
      timeout: timeout,
      browser_options: {
        "no-sandbox": nil,
        "disable-blink-features" => "AutomationControlled",
        "ignore-certificate-errors" => nil
      },
      ws_url: ENV["CHROMIUM_URL"],
      window_size: window_size
    )
  end

  def create_page(proxy: false, **args)
    page = super(
      proxy: proxy ? {
        host: ENV["PROXY_HOST"],
        port: ENV["PROXY_PORT"],
        user: ENV["PROXY_USERNAME"],
        password: ENV["PROXY_PASSWORD"]
      } : nil,
      **args
    )

    page.extend(Possum::Page)
    page.after_initialize
    page
  end
end
