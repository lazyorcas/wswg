module Flash
  extend ActiveSupport::Concern

  included do
    add_flash_types :info, :success, :warning, :error

    helper_method :turbo_stream_flash
  end

  def turbo_stream_flash
    turbo_stream.append "flash", partial: "shared/flash"
  end
end
