class Home::Events::DescriptionsController < ApplicationController
  include BotProtection

  protect_from_bots
  after_action :add_event_to_seen_events, only: [ :show ]

  def show
    load_event
    build_markdown_description
  end

  private

  def load_event
    @event = event_scope.find(params[:id])
  end

  def build_markdown_description
    description = @event.description.gsub(/(?<!\n)\n(?!\n)/, "<br/>")
    @markdown_description = markdown_renderer.render(description).html_safe

    ahoy.track "Viewed event description", event_id: @event.id
  end

  def add_event_to_seen_events
    Person::AddEventToSeenEventsJob.perform_later(
      person_type: Current.person.class.name,
      person_id: Current.person.id,
      event_id: @event.id
    )
  end

  def event_scope
    Event.all
  end

  def markdown_renderer
    @markdown_renderer ||= Redcarpet::Markdown.new(
      DescriptionMarkdownRenderer,
      autolink: false,
      no_images: true,
      no_links: true,
      no_styles: true,
      hard_wrap: true
    )
  end
end
