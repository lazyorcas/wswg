class Source::Eventbrite::EventsFinder < Source::EventsFinder
  private

  def max_page_count
    50
  end

  def get_events
    @page.css("a.event-card-link").each do |link|
      url = link.attribute("href")

      @events << {
        uid: url.split("?").first.split("/").last.split("-").last,
        url: url
      }
    end
  end

  def go_to_next_page
    @page.click_on("[aria-label=\"Next Page\"]")
  end
end
