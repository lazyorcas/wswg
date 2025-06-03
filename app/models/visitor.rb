class Visitor < ApplicationRecord
  include Credits

  belongs_to :city

  has_many :seens, as: :seenable, dependent: :destroy
  has_many :seen_events, through: :seens, source: :event
  has_many :search_queries, as: :searcher, dependent: :destroy

  has_many :visits, class_name: "Ahoy::Visit", primary_key: "visitor_token", foreign_key: "visitor_token"
end
