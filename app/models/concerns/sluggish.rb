module Sluggish
  extend ActiveSupport::Concern

  included do
    before_validation :set_slug, if: -> { slug.blank? && sluggish_field.present? }
  end

  def sluggish_field
    raise NotImplementedError
  end

  private

  def set_slug
    begin
      self.slug = sluggish_field.parameterize
    rescue => e
      Sentry.capture_exception(e, extra: { sluggish_field: sluggish_field })
    end
  end
end
