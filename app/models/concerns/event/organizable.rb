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

    organizer = if organizer_attributes[:url].present?
      Organizer.find_or_initialize_by(
        source: source,
        url: organizer_attributes[:url]
      )
    elsif organizer_attributes[:name].present?
      Organizer.find_or_initialize_by(
        source: source,
        name: organizer_attributes[:name]
      )
    end

    organizer.name ||= organizer_attributes[:name] if organizer.new_record?
    organizer.save!

    self.organizer = organizer
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
