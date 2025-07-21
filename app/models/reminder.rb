class Reminder
  include ActiveModel::Model

  AHOY_EVENT_NAME = "Remind me".freeze

  attr_accessor :contact, :event_id, :early_reminder

  validates :contact, presence: true
  validates :event, presence: true

  validate :event_must_exist

  def self.find_by(event_id: nil, contact: nil)
    ahoy_event = Ahoy::Event
      .where(name: AHOY_EVENT_NAME)
      .where("properties->>'event_id' = ?", event_id.to_s)
      .where("properties->>'contact' = ?", contact)
      .first

    return nil if ahoy_event.nil?

    self.new(
      event_id: ahoy_event.properties["event_id"],
      contact: ahoy_event.properties["contact"]
    )
  end

  def event
    @event ||= Event.find(event_id)
  end

  private

  def event_must_exist
    return if event.present?
    errors.add(:event_id, "must exist")
  end
end
