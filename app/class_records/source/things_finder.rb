class Source::ThingsFinder
  attr_reader :things

  def initialize
    @source = nil
    @things = []
  end

  def find_things(source_id)
    @source = Source.find(source_id)

    begin
      @browser = Possum::Browser.new
      @browser.go_to(@source.url)

      max_page_count.times do |page|
        @browser.wait_for_idle

        get_things
        begin
          go_to_next_page

          break if done?
        rescue
          break
        end
      end
    ensure
      begin
        @browser.reset
        @browser.quit
      rescue
        # ignore
      end
    end

    @things = @things.uniq { |thing| thing[:uid] }
  end

  private

  def max_page_count
    raise NotImplementedError
  end

  def get_things
    raise NotImplementedError
  end

  def go_to_next_page
    raise NotImplementedError
  end

  def done?
    false
  end

  def end_of_page?
    current_scroll = @browser.evaluate("window.pageYOffset + window.innerHeight")
    total_height = @browser.evaluate("document.documentElement.scrollHeight")
    current_scroll >= total_height
  end
end
