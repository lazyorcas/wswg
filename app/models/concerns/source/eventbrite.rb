module Source::Eventbrite
  include Source::EventsFindable

  private

  def max_page_count
    50
  end

  def get_event_urls(page:, city_source_url:, &block)
    page.css("a.event-card-link").each do |el|
      url = el.attribute("href")
      yield url
    end
  end

  def go_to_next_page(page:)
    page.click_on("[aria-label=\"Next Page\"]")
  end
end
