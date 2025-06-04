module Flash
  extend ActiveSupport::Concern

  included do
    add_flash_types :info, :success, :warning, :error

    helper_method :turbo_stream_flash
  end

  def turbo_stream_flash(status: nil)
    if status.present?
      render turbo_stream: turbo_stream.append("flash", partial: "shared/flash"), status: status

    else
      turbo_stream.append("flash", partial: "shared/flash")
    end
  end
end
