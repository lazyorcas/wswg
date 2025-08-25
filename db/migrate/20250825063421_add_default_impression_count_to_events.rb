class AddDefaultImpressionCountToEvents < ActiveRecord::Migration[8.0]
  def change
    change_column_default :events, :impression_count, from: nil, to: 0
  end
end

# Event.update_all(impression_count: nil)
