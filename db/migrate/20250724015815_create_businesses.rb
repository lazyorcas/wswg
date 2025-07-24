class CreateBusinesses < ActiveRecord::Migration[8.0]
  def change
    create_table :businesses do |t|
      t.belongs_to :city, null: false, foreign_key: true, index: true

      t.string :name, null: false
      t.string :slug, null: false
      t.string :logo_url

      t.timestamps
    end

    add_index :businesses, :slug, unique: true
  end
end
