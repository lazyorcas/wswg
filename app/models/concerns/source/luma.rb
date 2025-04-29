module Source::Luma
  include Source::EventsFindable

  private

  def max_page_count
    10
  end

  def get_event_urls(page:, city_source_url:, &block)
    base_url = Url.get_base_url(city_source_url)

    page.css("a.event-link").each do |el|
      path = el.attribute("href")
      url = Url.build_url(base_url, path)
      yield url
    end
  end

  def go_to_next_page(page:)
    page.scroll_to_load
  end

  def check_after_going_to_next_page?
    false
  end

  def done_after_going_to_next_page?(page:)
    page.end_of_page?
  end
end
