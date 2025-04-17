module Broadcastable
  def broadcast_error(message)
    broadcast_update_to(
      self,
      target: "flash",
      partial: "shared/flash",
      locals: {
        flash: {
          error: message
        }
      }
    )
  end
end
