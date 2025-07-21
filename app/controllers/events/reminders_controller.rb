class Events::RemindersController < ApplicationController
  before_action :load_event
  before_action :load_contact

  helper_method :has_reminder?

  def show
    load_contact
    load_reminder if @contact.present?
    if @reminder.present?
      @has_reminder = true
    else
      build_reminder
    end
  end

  def create
    ahoy.track "Created reminder", event_id: @event.id

    load_contact
    load_reminder if @contact.present?

    if @reminder.present?
      head(:ok) and return
    end

    build_reminder
    if @reminder.valid?
      ahoy.track Reminder::AHOY_EVENT_NAME, {
        event_id: @event.id,
        contact: @contact,
        early_reminder: @reminder.early_reminder
      }
      flash.now[:success] = "Reminder created successfully"
    else
      raise "Reminder is invalid"
    end
  end

  private

  def has_reminder?
    @has_reminder == true
  end

  def load_event
    @event = Event.find(params[:event_id])
  end

  def load_contact
    @contact = if Current.person.is_a?(Visitor)
      Current.person
        .events
        .where(name: Reminder::AHOY_EVENT_NAME)
        .where("properties->>'event_id' = ?", @event.id)
        .first
        &.properties["contact"]
    else
      Current.person.email
    end
  end

  def load_reminder
    @reminder = Reminder.find_by(event_id: @event.id, contact: @contact)
  end

  def build_reminder
    @reminder ||= Reminder.new
    @reminder.attributes = reminder_params
    @reminder.event_id = @event.id
    @reminder.contact ||= @contact
  end

  def reminder_params
    reminder_params = params[:reminder]
    reminder_params ? reminder_params.permit(:contact, :early_reminder) : {}
  end
end
