class ApplicationController < ActionController::Base
  before_action :render_device_not_supported, if: -> { browser.device.mobile? }

  include SetCurrentRequestDetails
  include Authentication

  add_flash_types :info, :success, :warning, :error

  helper_method :turbo_stream_flash

  private

  def turbo_stream_flash
    turbo_stream.append "flash", partial: "shared/flash"
  end

  def wday
    (today.wday + 6) % 7
  end

  def today
    @today ||= Time.current.in_time_zone(Current.user.city.time_zone).to_date
  end

  def render_device_not_supported
    render file: "#{Rails.root}/public/404-unsupported-device.html", layout: false, status: :not_found
  end
end
