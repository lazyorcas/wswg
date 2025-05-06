class ApplicationController < ActionController::Base
  include SetCurrentRequestDetails
  include Authentication
  include Dateful
  include Flash

  private

  def render_device_not_supported
    render file: "#{Rails.root}/public/404-unsupported-device.html", layout: false, status: :not_found
  end
end
