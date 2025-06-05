class AddForeignKeyToAhoyVisits < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :ahoy_visits, :visitors, column: :visitor_token, primary_key: :visitor_token
  end
end
