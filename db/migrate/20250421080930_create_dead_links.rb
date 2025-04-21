class CreateDeadLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :dead_links do |t|
      t.string :url, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
