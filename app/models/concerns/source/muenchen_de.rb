module Source::MuenchenDe
  include Source::EventsFindable

  private

  def max_page_count
    100
  end

  def get_event_urls(page:, city_source_url:, &block)
    base_url = Url.get_base_url(city_source_url)

    page.css(".m-event-list-item a").each do |el|
      url = el.attribute("href").split("?").first

      if url.start_with?("/")
        url = Url.build_url(base_url, url)
      end

      yield url
    end
  end

  def go_to_next_page(page:)
    page.click_on(".m-pagination__item.m-pagination__item--next-page a")
  end
end
