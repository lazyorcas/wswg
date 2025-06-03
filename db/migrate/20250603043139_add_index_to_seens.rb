class AddIndexToSeens < ActiveRecord::Migration[8.0]
  def change
    add_index :seens, [ :seenable_type, :seenable_id, :event_id ], unique: true
  end
end
