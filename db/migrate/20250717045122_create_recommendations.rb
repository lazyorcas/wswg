class CreateRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_view :recommendations
  end
end
