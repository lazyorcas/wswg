class CreateImpressions < ActiveRecord::Migration[8.0]
  def change
    create_table :impressions do |t|
      t.belongs_to :impressionable, polymorphic: true, null: false, index: true
      t.belongs_to :event, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :impressions, [ :impressionable_id, :impressionable_type, :event_id ], unique: true
  end
end
