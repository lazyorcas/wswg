module Localizable
  def localizable_field
    raise NotImplementedError
  end

  private

  def i18n_key
    @i18n_key ||= localizable_field.parameterize(separator: "_")
  end
end
