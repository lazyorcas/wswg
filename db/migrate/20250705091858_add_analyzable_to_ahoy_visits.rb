class AddAnalyzableToAhoyVisits < ActiveRecord::Migration[8.0]
  def change
    add_column :ahoy_visits, :analyzable, :boolean
  end
end
