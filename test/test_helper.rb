ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def login_as(user)
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
  end
end
