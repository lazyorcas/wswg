class DescriptionMarkdownRenderer < Redcarpet::Render::HTML
  def initialize(**renderer_options)
    super(
      no_images: true,
      no_links: true,
      no_styles: true,
      hard_wrap: true,
      **renderer_options
    )
  end

  def hrule
    %(<hr class="border-primary" />)
  end
end
