require "test_helper"

Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: Possum::Browser::WINDOW_SIZE)
end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :cuprite

  setup do
    ActionController::Base.allow_forgery_protection = true

    page.driver.add_headers(Possum::Page::Config::HEADERS)
    page.driver.add_headers(build_cloudflare_headers)
  end

  teardown do
    ActionController::Base.allow_forgery_protection = false
  end
end
