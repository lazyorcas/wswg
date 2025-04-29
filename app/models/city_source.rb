class CitySource < ApplicationRecord
  belongs_to :city
  belongs_to :source

  validates :url_params, presence: true

  def url
    @url ||= source.template_url % url_params
  end
end
