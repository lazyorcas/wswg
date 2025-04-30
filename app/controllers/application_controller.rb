class ApplicationController < ActionController::Base
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
    @today ||= Current.user.city.time_zone.current_date
  end

  def render_device_not_supported
    render file: "#{Rails.root}/public/404-unsupported-device.html", layout: false, status: :not_found
  end
end
