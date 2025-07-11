module Marketing::Localization
  def t(key, options = {})
    I18n.t("marketing.#{key}", **options)
  end

  private

  def i18n_defaults_key_prefix
    self.class.name.split("::").last.underscore
  end
end
