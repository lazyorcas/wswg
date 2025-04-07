class Source::City::UrlFinder::Base
  include Fetch::WithBrowser

  attr_reader :url

  def initialize
    @source = nil
    @city = nil
    @url = nil
  end

  def find_url(source_id:, city_id:)
    @source = Source.find(source_id)
    @city = City.find(city_id)

    load_browser
    begin
      @browser.go_to(@source.homepage_url)
      @url = find_url_in_browser
    ensure
      @browser.reset
    end
  end

  private

  def find_url_in_browser
    raise NotImplementedError
  end
end
