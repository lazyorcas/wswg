class Source::Meetup::EventsFinder < Source::EventsFinder
  private

  def max_page_count
    100
  end

  def get_events
    links = @page.css("[data-element-name=\"categoryResults-eventCard\"] a")

    # old selector
    if links.empty?
      links = @page.css("a#event-card-in-search-results")
    end

    links.each do |link|
      url = link.attribute("href").split("?").first

      @event_urls << url
    end
  end

  def go_to_next_page
    @page.scroll_to_load
  end

  def done?
    end_of_page?
  end
end
