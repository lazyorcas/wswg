class Source::City::UrlFinder::Luma < Source::City::UrlFinder::Base
  private

  def find_url_in_browser
    url = nil
    tab_index = 0
    tab_count = @browser.css(".tab").size

    browser_scroll_to_load

    host = URI.join(@source.homepage_url).host
    base_url = "https://#{host}"

    while tab_index < tab_count
      tab = @browser.css(".tab")[tab_index]
      tab.click

      @browser.css(".place-item").each do |link|
        if link.inner_text.downcase.include?(@city.name.downcase)
          path = link.attribute("href")
          url = URI.join(base_url, path).to_s
          break
        end
      end

      tab_index += 1
    end

    if url.present?
      url_handler = UrlHandler.new(url)
      url = url_handler.remove_params([ "k" ])
    end

    url
  end
end
