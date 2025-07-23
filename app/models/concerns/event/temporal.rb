module Event::Temporal
  extend ActiveSupport::Concern

  included do
    before_validation :set_dow, if: -> { start_date.present? }

    validates :end_date,
      comparison: { greater_than_or_equal_to: :start_date },
      if: -> { end_date.present? && start_date.present? }

    validates :end_time,
      comparison: { greater_than_or_equal_to: :start_time },
      if: -> { end_time.present? && start_time.present? }

    validate :validate_end_date_after_start_date, if: -> { end_date.present? && start_date.present? }, on: :create
  end

  def has_started?
    "#{start_date} #{start_time}" <= "#{city.time_zone.current_date} #{city.time_zone.current_time}"
  end

  def has_ended?
    end_date < city.time_zone.current_date.to_s
  end

  private

  def set_dow
    self.dow = Date.parse(start_date).strftime("%u").to_i
  end

  def validate_end_date_after_start_date
    return if end_date >= start_date
    errors.add(:end_date, "must be greater than or equal to the current date")
  end
end
