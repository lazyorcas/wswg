module BotProtection
  extend ActiveSupport::Concern

  class_methods do
    def protect_from_bots(options = {})
      if Rails.env.production?
        before_action -> { head(:forbidden) }, { if: -> { browser.bot? } }.merge(options)
      end
    end
  end
end
