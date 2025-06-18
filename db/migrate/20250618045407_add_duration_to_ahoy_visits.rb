class AddDurationToAhoyVisits < ActiveRecord::Migration[8.0]
  def change
    add_column :ahoy_visits, :duration, :integer
    add_column :ahoy_visits, :duration_synced_at, :datetime
  end
end
