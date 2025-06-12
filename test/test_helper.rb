ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "capybara/cuprite"
require "passwordless/test_helpers"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def login_as(user)
      if rand(2) == 0
        login_with_passwordless(user)
      else
        login_with_omniauth(user)
      end
    end

    def login_with_passwordless(user)
      passwordless_sign_in(user)
    end

    def login_with_omniauth(user)
      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:developer] = OmniAuth::AuthHash.new({
        provider: "developer",
        uid: user.id,
        info: {
          email: user.email,
          image: "https://example.com/image.png"
        },
        credentials: {
          token: 1,
          expires_at: 1.day.from_now.to_i
        }
      })

      get "/auth/developer/callback"
      follow_redirect! if response.redirect?
    end

    def build_cloudflare_headers
      city = cities(:singapore)
      {
        # https://lite.ip2location.com/singapore-ip-address-ranges
        "CF_CONNECTING_IP" => "1.21.224.0",
        "CF_IPCITY" => city.name.to_s,
        "CF_TIMEZONE" => city.time_zone.name.to_s,
        "CF_IPLATITUDE" => city.lat.to_s,
        "CF_IPLONGITUDE" => city.lon.to_s
      }
    end

    def build_cloudflare_http_headers
      build_cloudflare_headers.transform_keys { |key| "HTTP_#{key}" }
    end
  end
end
