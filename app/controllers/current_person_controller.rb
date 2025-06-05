class CurrentPersonController < ApplicationController
  include BotProtection

  protect_from_bots

  def top_up_needed; end
end
