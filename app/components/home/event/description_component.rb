class Home::Event::DescriptionComponent < ViewComponent::Base
  def initialize(event)
    @event = event
  end

  def markdown_description
    description = @event.description.gsub(/(?<!\n)\n(?!\n)/, "<br/>")
    markdown_renderer.render(description).html_safe
  end

  def markdown_renderer
    @markdown_renderer ||= Redcarpet::Markdown.new(
      DescriptionMarkdownRenderer,
      autolink: false
    )
  end
end
