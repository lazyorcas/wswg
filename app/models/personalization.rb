class Personalization
  include ActiveModel::Model

  MEDIUMS = %w[email_newsletter discovery_feed telegram_channel whatsapp_channel].freeze
  FREQUENCIES = %w[daily weekly monthly].freeze

  FIELDS = [ :medium, :frequency, :reason, :keywords, :email, :telegram_username, :whatsapp_number ].freeze

  STEPS = {
    email_newsletter: [ :frequency, :keywords, :reason, :email ],
    discovery_feed: [ :frequency, :keywords, :reason, :email ],
    telegram_channel: [ :frequency, :keywords, :reason, :telegram_username ],
    whatsapp_channel: [ :frequency, :keywords, :reason, :whatsapp_number ]
  }.freeze
  REQUIRED_STEPS = {
    email_newsletter: [ :frequency, :email ],
    discovery_feed: [ :frequency, :email ],
    telegram_channel: [ :frequency, :telegram_username ],
    whatsapp_channel: [ :frequency, :whatsapp_number ]
  }

  validates :medium,
    inclusion: { in: MEDIUMS },
    if: -> { medium.present? }
  validates :frequency,
    inclusion: { in: FREQUENCIES },
    if: -> { frequency.present? }
  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    if: -> { email.present? }

  def initialize(person)
    @person = person
  end

  FIELDS.each do |step|
    define_method("#{step}=") do |value|
      person_personalization_settings.send("#{step}=", value)
    end

    define_method(step) do
      person_personalization_settings.send(step)
    end
  end

  def steps
    medium.present? ? STEPS[medium.to_sym] : []
  end

  def required_steps
    medium.present? ? REQUIRED_STEPS[medium.to_sym] : []
  end

  def next_step
    if medium.nil?
      :medium
    elsif complete?
      nil
    else
      steps.find { |step| send(step).nil? }
    end
  end

  def complete?
    medium.present? && required_steps.all? { |step| send(step).present? }
  end

  def save!
    person_personalization_settings.save!
  end

  private

  def person_personalization_settings
    @person.settings(:personalization)
  end
end
