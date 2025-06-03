class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  scope :non_user, -> { where(user_id: nil) }

  belongs_to :visitor, primary_key: "visitor_token", foreign_key: "visitor_token"
  belongs_to :user, optional: true

  has_many :events, class_name: "Ahoy::Event", dependent: :destroy

  before_validation :find_or_create_visitor

  private

  def find_or_create_visitor
    Visitor.find_or_create_by(visitor_token: visitor_token)
  end
end
