class Source::Eventbrite::ThingsFinder < Source::ThingsFinder
  private

  def max_page_count
    50
  end

  def get_things
    @page.css("a.event-card-link").each do |link|
      url = link.attribute("href")

      @things << {
        uid: url.split("?").first.split("/").last.split("-").last,
        url: url
      }
    end
  end

  def go_to_next_page
    @page.click_on("[aria-label=\"Next Page\"]")
  end
end
