module Event::HandlesSources::Luma
  extend ActiveSupport::Concern

  included do
    before_validation :build_unique_url_for_luma, if: -> { from_luma? && start_date.present? }
  end

  def from_luma?
    source.name == "Luma"
  end

  private

  def build_unique_url_for_luma
    self.url = Url.get_parameterized_url(url, { date: start_date })
  end
end
