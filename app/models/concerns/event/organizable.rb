module Event::Organizable
  extend ActiveSupport::Concern

  included do
    belongs_to :organizer, optional: true

    before_validation :assign_organizer, if: -> { organizer_url.present? || organizer_name.present? }, on: :create
  end

  def assign_organizer
    return if organizer_data_sanitizer_class.nil?

    sanitizer = organizer_data_sanitizer_class.new(
      url: organizer_url,
      name: organizer_name,
      event_url: url
    )
    sanitizer.sanitize
    organizer_attributes = sanitizer.sanitized_attributes

    return if organizer_attributes.blank?

    self.organizer = Organizer.find_or_create_by(
      source: source,
      **organizer_attributes
    )
  end

  def assign_organizer!
    assign_organizer
    save!
  end

  private

  def organizer_data_sanitizer_class
    "Organizer::#{source.name.classify}DataSanitizer".constantize
  rescue NameError
    Organizer::DataSanitizer
  end
end
