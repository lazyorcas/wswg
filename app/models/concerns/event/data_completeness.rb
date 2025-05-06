module Event::DataCompleteness
  extend ActiveSupport::Concern

  included do
    validate :validate_date_completeness
  end

  def data_completed?
    data_completeness_fields.all? { |field| send(field).present? }
  end

  private

  def data_completeness_fields
    [ :title, :image_url, :start_date, :end_date, :start_time ]
  end

  def validate_date_completeness
    return if data_completed?

    data_completeness_fields.each do |attribute|
      errors.add(attribute, "must be present") if send(attribute).blank?
    end

    errors.add(:base, :data_incomplete)
  end
end
