class ChangelogController < ApplicationController
  before_action :require_user!

  layout "plain"

  def index
    path = Rails.root.join("app/views/changelog/changelog.md.erb")
    erb_content = File.read(path)
    erb_result = ERB.new(erb_content).result(binding)

    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer)

    @content = markdown.render(erb_result)
  end
end
