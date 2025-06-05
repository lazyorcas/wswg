module BotProtection
  extend ActiveSupport::Concern

  class_methods do
    def protect_from_bots(options = {})
      before_action -> { head(:forbidden) }, { if: browser.bot? }.merge(options)
    end
  end
end
