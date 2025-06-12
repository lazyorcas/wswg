require "test_helper"

class ApplicationControllerTestCase < ActionDispatch::IntegrationTest
  BOT_USER_AGENT = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)".freeze

  def build_human_headers
    {
      **Possum::Page::Config::HEADERS,
      **build_cloudflare_http_headers
    }
  end

  def build_bot_headers
    {
      "HTTP_USER_AGENT" => BOT_USER_AGENT,
      **build_cloudflare_http_headers
    }
  end
end
