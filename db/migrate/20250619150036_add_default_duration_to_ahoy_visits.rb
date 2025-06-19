class AddDefaultDurationToAhoyVisits < ActiveRecord::Migration[8.0]
  def change
    change_column_default :ahoy_visits, :duration, from: nil, to: 0
  end
end
