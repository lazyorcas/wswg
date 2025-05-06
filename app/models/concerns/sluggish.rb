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
    self.slug = sluggish_field.parameterize
  end
end
