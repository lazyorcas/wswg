class Marketing::EventsPageBuilder
  include Marketing::SEO
  include Marketing::Events
  include Marketing::Events::SEO
  include Marketing::Localization

  def no_events_message
    t("no_events_message", i18n_params)
  end
end
