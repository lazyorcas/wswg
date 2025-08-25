class AddImpressionCountToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :impression_count, :integer
  end
end
