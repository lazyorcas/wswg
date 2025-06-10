class DescriptionMarkdownRenderer < Redcarpet::Render::HTML
  def hrule
    %(<hr class="border-primary" />)
  end
end
