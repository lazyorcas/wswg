class AddTimeZoneToAhoyVisits < ActiveRecord::Migration[8.0]
  def change
    add_column :ahoy_visits, :time_zone, :string
  end
end
