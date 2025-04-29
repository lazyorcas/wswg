class Source::Luma::EventsFinder < Source::EventsFinder
  private

  def max_page_count
    10
  end

  def get_events
    @page.css("a.event-link").each do |link|
      path = link.attribute("href")
      url = URI.join(base_url, path).to_s

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
