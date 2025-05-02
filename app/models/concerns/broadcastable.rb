module Broadcastable
  extend ActiveSupport::Concern

  def broadcast_error(broadcastable, message)
    broadcast_update_to(
      broadcastable,
      target: "flash",
      partial: "shared/flash",
      locals: {
        flash: {
          "error" => message
        }
      }
    )
  end
end
