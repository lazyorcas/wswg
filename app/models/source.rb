class Source < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :template_url, presence: true
end
