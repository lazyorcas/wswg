module Marketing::Events::SEO
  include Marketing::Localization
  include AlternateLinks

  def build_meta_title
    begin
      t("meta_title.#{city_i18n_key}.#{event_category_i18n_key}.#{time_period_i18n_key}")
    rescue
      t("defaults.#{i18n_defaults_key_prefix}.meta_title", i18n_params)
    end.professionalize
  end

  def build_meta_description
    begin
      t("meta_description.#{city_i18n_key}.#{event_category_i18n_key}.#{time_period_i18n_key}")
    rescue
      t("defaults.#{i18n_defaults_key_prefix}.meta_description", i18n_params)
    end.professionalize
  end

  def build_title
    begin
      t("title.#{city_i18n_key}.#{event_category_i18n_key}.#{time_period_i18n_key}")
    rescue
      t("defaults.#{i18n_defaults_key_prefix}.title", i18n_params)
    end.professionalize
  end

  def build_description
    build_meta_description
  end

  def no_events_message
    t("no_events_message", { event_category: @event_category.name })
  end

  private

  def city_i18n_key
    @city.i18n_key
  end

  def event_category_i18n_key
    @event_category.i18n_key
  end

  def time_period_i18n_key
    @time_period.i18n_key
  end

  def i18n_params
    raise NotImplementedError
  end
end
