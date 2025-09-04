# https://railsnotes.xyz/blog/ferrum-stealth-browsing

class Possum::Browser < Ferrum::Browser
  TIMEOUT = 20
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
        "disable-blink-features" => "AutomationControlled"
      },
      ws_url: ENV["CHROMIUM_URL"],
      window_size: window_size,
      extensions: [ Rails.root.join("lib", "possum", "stealth.min.js") ]
    )
  end

  def create_page(proxy: false, country_code: nil, **args)
    page = super(
      proxy: proxy ? {
        host: ENV["PROXY_HOST"],
        port: ENV["PROXY_PORT"],
        user: ENV["PROXY_USERNAME"],
        password:
          country_code.present? ?
            "#{ENV['PROXY_PASSWORD']}_area-#{country_code}" :
            ENV["PROXY_PASSWORD"]
      } : nil,
      **args
    )

    page.extend(Possum::Page)
    page.after_initialize
    page
  end
end
