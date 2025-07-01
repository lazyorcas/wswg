module PersonalizationHelper
  def personalization_medium_icon(medium)
    case medium
    when "email_newsletter"
      "ph-newspaper"
    when "discovery_feed"
      "ph-sparkle"
    when "telegram_channel"
      "ph-telegram-logo"
    when "whatsapp_channel"
      "ph-whatsapp-logo"
    end
  end
end
