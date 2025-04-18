class Source::Eventbrite::ThingsFinder < Source::ThingsFinder
  private

  def max_page_count
    50
  end

  def get_things
    @browser.css("a.event-card-link").each do |link|
      url = link.attribute("href")

      @things << {
        uid: url.split("?").first.split("/").last.split("-").last,
        url: url
      }
    end
  end

  def go_to_next_page
    @browser.at_css("[aria-label=\"Next Page\"]").click
  end
end
