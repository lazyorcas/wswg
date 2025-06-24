class Personalization
  include ActiveModel::Model

  STEPS = [ :medium, :frequency, :reason, :email ].freeze

  validates :medium,
    inclusion: { in: %w[newsletter discovery_feed] },
    if: -> { medium.present? }
  validates :frequency,
    inclusion: { in: %w[daily weekly monthly] },
    if: -> { frequency.present? }
  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    if: -> { email.present? }

  def initialize(person)
    @person = person
  end

  STEPS.each do |step|
    define_method("#{step}=") do |value|
      person_personalization_settings.send("#{step}=", value)
    end

    define_method(step) do
      person_personalization_settings.send(step)
    end
  end

  def next_step
    if complete?
      nil
    else
      STEPS.find { |step| !send(step).present? }
    end
  end

  def complete?
    STEPS.all? { |step| send(step).present? }
  end

  def save!
    person_personalization_settings.save!
  end

  private

  def person_personalization_settings
    @person.settings(:personalization)
  end
end
